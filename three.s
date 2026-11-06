// ============================================================
// Bài 3 – Kiểm tra số chính phương
// Số chính phương là số nguyên không âm, là bình phương của 1 số khác
// Cách làm
// + Cho biến i con chạy, chạy từ 1 (hoặc 0)
// + Nếu i*i = input => số chính phương
// + Nếu chạy đến i * i > input thì dừng (không phải số chính phương)
// ============================================================

// Khai báo thư viện
.extern printf
.extern scanf

// Vùng data khai báo thông báo với  format số integer
.section .data
    tb1: .asciz "Please enter number n:\n"
    tb2: .asciz "Perfect Square \n"
    tb3: .asciz "Not a Perfect Square \n"
    tb4: .asciz "Invalid Number \n"
    fmt_in: .asciz "%ld"

// Khai báo biến số n
.section .bss 
    n: .space 8

// Mặc định
.section .text
.global main

main:
// ------------------------------------------------------------
// 1. In thông báo nhập số n
// ------------------------------------------------------------
    ADRP X0, tb1
    ADD  X0, X0, :lo12:tb1
    BL   printf


// Nhập số nguyên n
    ADRP X0, fmt_in  // gán địa chỉ fmt_in vào thanh ghi X0
    ADD X0, X0, :lo12:fmt_in // lấy 12 bit cuối gán vô X0 cho đầy dủ

// kiểm tra số âm
    CMP X19, #0
    B.LT NOT_PERFECT_SQUARE

// tương tụ
    ADRP X1, n  
    ADD X1, X1, :lo12:n

    BL scanf

// Kiểm tra số nhập vào phải đúng format không
    CMP W0, #1
    B.NE INVALID_INPUT

// Đọc giá trị vô biến X19
    ADRP X9, n //  lấy địa chỉ n gán vô X9
    ADD X19, X9, :lo12:n // lấy đầy đủ địa chỉ
    LDUR X19, [X19, #0] //  load giá trị vô X19

// Kiểm tra số âm
    CMP X19, #0
    B.LT NOT_PERFECT_SQUARE

// check 0 là số chính phương
    CMP X19, #0
    B.EQ PERFECT_SQUARE


// Khởi tạo con chạy i
    MOVZ X20, #1

LOOP:
    // Tính i * i
    MUL X21, X20, X20

    // nếu X21 = input => số chính phương
    CMP X21, X19
    B.EQ PERFECT_SQUARE

    // nếu X21 lớn hơn input dừng lại báo không phải
    B.GT NOT_PERFECT_SQUARE

    // tăng con chạy lên 1
    ADD X20, X20, #1
    B LOOP 


INVALID_INPUT:
    ADRP X0, tb4
    ADD X0, X0, :lo12:tb4
    BL printf
    B EXIT

NOT_PERFECT_SQUARE:
    ADRP X0, tb3
    ADD X0, X0, :lo12:tb3
    BL printf
    B EXIT

PERFECT_SQUARE:
    ADRP X0, tb2
    ADD X0, X0, :lo12:tb2
    BL printf
    B EXIT

EXIT:
    MOV  X0, #0
    MOV X8, #93
    SVC #0