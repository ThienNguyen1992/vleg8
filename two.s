
// ============================================================
// Bài 2 – Kiểm tra số hoàn thiện
// Số hoàn thiện là số nguyên dương mà tổng các ước số(trừ chính nó) bằng chính nó
// ví dụ: 6 có 3 ước là 1,2,3; tổng 1,2,3 = 6 (số hoàn thiện tính từ số 6)
// Cách làm
// + Vì vleg8 không có hàm chia hết nên xài vòng lặp
// + Từ biến con chạy lấy input trừ cho biến con chạy, cuối cùng kết quả = 0 => là ước
// + Tạo biến sum để cộng ước đó, cuối cùng so sánh sum với số ban đầu
// ============================================================

// Khai báo thư viện
.extern printf
.extern scanf

// Vùng data khai báo thông báo với  format số integer
.section .data
    tb1: .asciz "Please enter number n:\n"
    tb2: .asciz "Perfect Number \n"
    tb3: .asciz "Not a Perfect Number \n"
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

// 5. Kiem tra n <= 5
    CMP X19, #5
    B.LE NOT_PERFECT

// khởi tạo biến con chạy vs sum ban đầu là 0
    MOVZ X20, #1
    MOVZ X21, #0

    LOOP:
    // Kiểm tra nếu con chay X20 lớn hơn hoặc bằng input thì dừng
    // để kiểm tra kết quả
    CMP X20, X19
    B.GE CHECK_RESULT

INVALID_INPUT:
    ADRP X0, tb4
    ADD X0, X0, :lo12:tb4
    BL printf
    B EXIT

CHECK_RESULT:
    // Nếu sum = input => là số hoàn thiện
    // ngược lại không phải
    CMP X22, X19
    B.EQ PERFECT

    NOT_PERFECT

NOT_PERFECT:
    ADRP X0, tb3
    ADD X0, X0, :lo12:tb3
    BL printf
    B EXIT

PERFECT:
    ADRP X0, tb2
    ADD X0, X0, :lo12:tb2
    BL printf
    B EXIT

EXIT:
    MOV  X0, #0
    MOV X8, #93
    SVC #0