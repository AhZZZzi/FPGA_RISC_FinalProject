import tkinter as tk
from tkinter import ttk
import re

class RiscvCompleteAssemblerEngine:
    def __init__(self):
        # Full RISC-V Register Map (x0 - x31) with standard ABI names
        self.regs = {}
        for i in range(32):
            self.regs[f"x{i}"] = i
            
        # Standard ABI aliases matching academic benchmarks
        abi_aliases = {
            'zero': 0, 'ra': 1, 'sp': 2, 'gp': 3, 'tp': 4,
            't0': 5, 't1': 6, 't2': 7, 's0': 8, 'fp': 8, 's1': 9,
            'a0': 10, 'a1': 11, 'a2': 12, 'a3': 13, 'a4': 14, 'a5': 15, 'a6': 16, 'a7': 17,
            's2': 18, 's3': 19, 's4': 20, 's5': 21, 's6': 22, 's7': 23, 's8': 24, 's9': 25, 's10': 26, 's11': 27,
            't3': 28, 't4': 29, 't5': 30, 't6': 31
        }
        for name, num in abi_aliases.items():
            self.regs[f"${name}"] = num
            self.regs[name] = num

        # --- RISC-V ISA Mapping Matrices ---
        # R-Type: [funct7 (7b) | rs2 (5b) | rs1 (5b) | funct3 (3b) | rd (5b) | opcode (7b)]
        self.r_types = {
            'add':  {'op': 0x33, 'f3': 0x0, 'f7': 0x00},
            'sub':  {'op': 0x33, 'f3': 0x0, 'f7': 0x20},
            'sll':  {'op': 0x33, 'f3': 0x1, 'f7': 0x00},
            'slt':  {'op': 0x33, 'f3': 0x2, 'f7': 0x00},
            'sltu': {'op': 0x33, 'f3': 0x3, 'f7': 0x00},
            'xor':  {'op': 0x33, 'f3': 0x4, 'f7': 0x00},
            'srl':  {'op': 0x33, 'f3': 0x5, 'f7': 0x00},
            'sra':  {'op': 0x33, 'f3': 0x5, 'f7': 0x20},
            'or':   {'op': 0x33, 'f3': 0x6, 'f7': 0x00},
            'and':  {'op': 0x33, 'f3': 0x7, 'f7': 0x00}
        }

        # I-Type: [imm[11:0] (12b) | rs1 (5b) | funct3 (3b) | rd (5b) | opcode (7b)]
        self.i_types = {
            'addi':  {'op': 0x13, 'f3': 0x0},
            'slti':  {'op': 0x13, 'f3': 0x2},
            'sltiu': {'op': 0x13, 'f3': 0x3},
            'xori':  {'op': 0x13, 'f3': 0x4},
            'ori':   {'op': 0x13, 'f3': 0x6},
            'andi':  {'op': 0x13, 'f3': 0x7},
            'lw':    {'op': 0x03, 'f3': 0x2},
            'lb':    {'op': 0x03, 'f3': 0x0},
            'lh':    {'op': 0x03, 'f3': 0x1},
            'jalr':  {'op': 0x67, 'f3': 0x0}
        }

        # S-Type: [imm[11:5] (7b) | rs2 (5b) | rs1 (5b) | funct3 (3b) | imm[4:0] (5b) | opcode (7b)]
        self.s_types = {
            'sw': {'op': 0x23, 'f3': 0x2},
            'sb': {'op': 0x23, 'f3': 0x0},
            'sh': {'op': 0x23, 'f3': 0x1}
        }

        # B-Type: [imm[12|10:5] (7b) | rs2 (5b) | rs1 (5b) | funct3 (3b) | imm[4:1|11] (5b) | opcode (7b)]
        self.b_types = {
            'beq':  {'op': 0x63, 'f3': 0x0},
            'bne':  {'op': 0x63, 'f3': 0x1},
            'blt':  {'op': 0x63, 'f3': 0x4},
            'bge':  {'op': 0x63, 'f3': 0x5},
            'bltu': {'op': 0x63, 'f3': 0x6},
            'bgeu': {'op': 0x63, 'f3': 0x7}
        }

        # U-Type: [imm[31:12] (20b) | rd (5b) | opcode (7b)]
        self.u_types = {
            'lui':   {'op': 0x37},
            'auipc': {'op': 0x17}
        }

        # J-Type: [imm[20|10:1|11|19:12] (20b) | rd (5b) | opcode (7b)]
        self.j_types = {
            'jal': {'op': 0x6F}
        }

    def clean(self, token):
        return token.strip().replace(',', '')

    def parse_imm(self, token):
        token = self.clean(token)
        if token.lower().startswith('0x'):
            return int(token, 16)
        return int(token)

    def translate_line(self, line):
        line = line.split('#')[0].strip()
        if not line: return "", ""

        tokens = [self.clean(t) for t in re.split(r'\s+', line) if t]
        if not tokens: return "", ""
        
        instr = tokens[0].lower()

        try:
            # 1. R-TYPE TRANSLATION
            if instr in self.r_types:
                meta = self.r_types[instr]
                rd  = self.regs[tokens[1]]
                rs1 = self.regs[tokens[2]]
                rs2 = self.regs[tokens[3]]
                
                raw = (meta['f7'] << 25) | (rs2 << 20) | (rs1 << 15) | (meta['f3'] << 12) | (rd << 7) | meta['op']
                binary = f"{meta['f7']:07b} {rs2:05b} {rs1:05b} {meta['f3']:03b} {rd:05b} {meta['op']:07b}"
                return binary, f"0x{raw:08X}"

            # 2. I-TYPE TRANSLATION
            elif instr in self.i_types:
                meta = self.i_types[instr]
                if instr == 'lw' or instr == 'lb' or instr == 'lh':
                    rd = self.regs[tokens[1]]
                    match = re.match(r'([-\w]+)\((.*?)\)', tokens[2])
                    imm = self.parse_imm(match.group(1)) & 0xFFF
                    rs1 = self.regs[match.group(2)]
                else:
                    rd  = self.regs[tokens[1]]
                    rs1 = self.regs[tokens[2]]
                    imm = self.parse_imm(tokens[3]) & 0xFFF

                raw = (imm << 20) | (rs1 << 15) | (meta['f3'] << 12) | (rd << 7) | meta['op']
                binary = f"{imm:012b} {rs1:05b} {meta['f3']:03b} {rd:05b} {meta['op']:07b}"
                return binary, f"0x{raw:08X}"

            # 3. S-TYPE TRANSLATION
            elif instr in self.s_types:
                meta = self.s_types[instr]
                rs2 = self.regs[tokens[1]]
                match = re.match(r'([-\w]+)\((.*?)\)', tokens[2])
                imm = self.parse_imm(match.group(1)) & 0xFFF
                rs1 = self.regs[match.group(2)]
                
                imm_11_5 = (imm >> 5) & 0x7F
                imm_4_0  = imm & 0x1F

                raw = (imm_11_5 << 25) | (rs2 << 20) | (rs1 << 15) | (meta['f3'] << 12) | (imm_4_0 << 7) | meta['op']
                binary = f"{imm_11_5:07b} {rs2:05b} {rs1:05b} {meta['f3']:03b} {imm_4_0:05b} {meta['op']:07b}"
                return binary, f"0x{raw:08X}"

            # 4. B-TYPE TRANSLATION
            elif instr in self.b_types:
                meta = self.b_types[instr]
                rs1 = self.regs[tokens[1]]
                rs2 = self.regs[tokens[2]]
                imm = self.parse_imm(tokens[3]) & 0x1FFF # 13-bit sign-extended space
                
                # RISC-V Scrambled branch immediate structure mapping
                b12   = (imm >> 12) & 0x1
                b10_5 = (imm >> 5)  & 0x3F
                b4_1  = (imm >> 1)  & 0xF
                b11   = (imm >> 11) & 0x1
                
                upper_7 = (b12 << 6) | b10_5
                lower_5 = (b4_1 << 1) | b11

                raw = (upper_7 << 25) | (rs2 << 20) | (rs1 << 15) | (meta['f3'] << 12) | (lower_5 << 7) | meta['op']
                binary = f"{b12:01b}{b10_5:06b} {rs2:05b} {rs1:05b} {meta['f3']:03b} {b4_1:04b}{b11:01b} {meta['op']:07b}"
                return binary, f"0x{raw:08X}"

            # 5. U-TYPE TRANSLATION
            elif instr in self.u_types:
                meta = self.u_types[instr]
                rd = self.regs[tokens[1]]
                imm = self.parse_imm(tokens[2]) & 0xFFFFF # 20-bit upper layout boundary

                raw = (imm << 12) | (rd << 7) | meta['op']
                binary = f"{imm:020b} {rd:05b} {meta['op']:07b}"
                return binary, f"0x{raw:08X}"

            # 6. J-TYPE TRANSLATION
            elif instr in self.j_types:
                meta = self.j_types[instr]
                rd = self.regs[tokens[1]]
                imm = self.parse_imm(tokens[2]) & 0x1FFFFF # 21-bit execution space
                
                # RISC-V Scrambled jump immediate structure mapping
                j20   = (imm >> 20) & 0x1
                j10_1 = (imm >> 1)  & 0x3FF
                j11   = (imm >> 11) & 0x1
                j19_12= (imm >> 12) & 0xFF
                
                scrambled_imm = (j20 << 19) | (j19_12 << 11) | (j11 << 10) | j10_1

                raw = (scrambled_imm << 12) | (rd << 7) | meta['op']
                binary = f"{j20:01b}{j10_1:010b}{j11:01b}{j19_12:08b} {rd:05b} {meta['op']:07b}"
                return binary, f"0x{raw:08X}"

            else:
                return f"ERROR: Unrecognized mnemonic Sequence -> '{instr}'", ""

        except (IndexError, KeyError) as err:
            return f"ERROR: Field breakdown constraint violation -> {str(err)}", ""


class OmnipotentRiscvApp:
    def __init__(self, root):
        self.root = root
        self.root.title("RISC-V Universal Cross-Compilation Engine (RV32I)")
        self.root.geometry("1000x700")
        
        self.engine = RiscvCompleteAssemblerEngine()
        self.build_ui()

    def build_ui(self):
        self.root.configure(background='#F3F4F6')
        style = ttk.Style()
        style.theme_use('clam')
        style.configure('TLabel', font=('Segoe UI', 10), background='#F3F4F6')
        style.configure('Header.TLabel', font=('Segoe UI', 14, 'bold'), foreground='#1E3A8A')
        style.configure('Go.TButton', font=('Segoe UI', 10, 'bold'), foreground='#FFFFFF', background='#2563EB')
        style.map('Go.TButton', background=[('active', '#1D4ED8')])

        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.pack(fill=tk.BOTH, expand=True)

        ttk.Label(main_frame, text="Universal RISC-V (RV32I) Bitfield Parsing Workspace", style="Header.TLabel").pack(anchor=tk.W, pady=(0, 15))
        ttk.Label(main_frame, text="Enter RISC-V Assembly (Supports x-registers or standard names like sp, t0, a0):").pack(anchor=tk.W, pady=(0, 5))
        
        self.txt_in = tk.Text(main_frame, height=10, font=('Consolas', 11), wrap=tk.NONE, relief=tk.SOLID, bd=1)
        self.txt_in.pack(fill=tk.X, pady=(0, 15))
        
        # Seed test sequence representing EVERY type configuration layout
        self.txt_in.insert(tk.END, "add  x5, x6, x7          # R-Type: add rd, rs1, rs2\naddi t0, zero, 15        # I-Type: addi rd, rs1, imm\nlw   x10, 4(sp)          # I-Type Memory: lw rd, offset(rs1)\nsw   x10, 8(sp)          # S-Type: sw rs2, offset(rs1)\nbeq  t0, zero, -12       # B-Type: beq rs1, rs2, offset\nlui  a0, 0x12345         # U-Type: lui rd, imm20\njal  ra, -48             # J-Type: jal rd, offset")

        btn_bar = ttk.Frame(main_frame)
        btn_bar.pack(fill=tk.X, pady=(0, 15))
        ttk.Button(btn_bar, text="Deconstruct & Synthesize", style="Go.TButton", command=self.run_assembler).pack(side=tk.LEFT, padx=(0, 10))
        ttk.Button(btn_bar, text="Reset Canvas", command=self.wipe).pack(side=tk.LEFT)

        grid = ttk.Frame(main_frame)
        grid.pack(fill=tk.BOTH, expand=True)
        grid.columnconfigure(0, weight=4)
        grid.columnconfigure(1, weight=1)
        grid.rowconfigure(1, weight=1)

        ttk.Label(grid, text="Deconstructed Instruction Bit-fields (Type-Structured Boundaries):").grid(row=0, column=0, sticky=tk.W, pady=(0,5))
        self.txt_bin = tk.Text(grid, font=('Consolas', 11), wrap=tk.NONE, relief=tk.SOLID, bd=1, bg='#F9FAFB', state=tk.DISABLED)
        self.txt_bin.grid(row=1, column=0, sticky=tk.NSEW, padx=(0,10))

        ttk.Label(grid, text="Compiled Hex Payload:").grid(row=0, column=1, sticky=tk.W, pady=(0,5))
        self.txt_hex = tk.Text(grid, font=('Consolas', 11), wrap=tk.NONE, relief=tk.SOLID, bd=1, bg='#F9FAFB', state=tk.DISABLED)
        self.txt_hex.grid(row=1, column=1, sticky=tk.NSEW)

    def run_assembler(self):
        lines = self.txt_in.get("1.0", tk.END).split('\n')
        b_list, h_list = [], []

        for line in lines:
            if line.strip():
                b, h = self.engine.translate_line(line)
                if h == "" and "ERROR" in b:
                    b_list.append(b)
                    h_list.append("FAIL")
                else:
                    b_list.append(b)
                    h_list.append(h)
            else:
                b_list.append("")
                h_list.append("")

        self.txt_bin.configure(state=tk.NORMAL); self.txt_hex.configure(state=tk.NORMAL)
        self.txt_bin.delete("1.0", tk.END); self.txt_hex.delete("1.0", tk.END)
        self.txt_bin.insert(tk.END, "\n".join(b_list)); self.txt_hex.insert(tk.END, "\n".join(h_list))
        self.txt_bin.configure(state=tk.DISABLED); self.txt_hex.configure(state=tk.DISABLED)

    def wipe(self):
        self.txt_in.delete("1.0", tk.END)
        self.txt_bin.configure(state=tk.NORMAL); self.txt_hex.configure(state=tk.NORMAL)
        self.txt_bin.delete("1.0", tk.END); self.txt_hex.delete("1.0", tk.END)
        self.txt_bin.configure(state=tk.DISABLED); self.txt_hex.configure(state=tk.DISABLED)

if __name__ == "__main__":
    win = tk.Tk()
    app = OmnipotentRiscvApp(win)
    win.mainloop()