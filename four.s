
// ============================================================
// Bài 4 – Kiểm tra số đối xứng
// Số đối xứng là số mà đọc từ trái sang phải hay từ phải sang trái thì giống nhau
// Cách làm
// + Lưu số ban đầu để so sánh
// + Tạo biến lưu số reverse để lưu số đảo ngược
// + Cách tạo số đảo ngược: lấy chữ số cuối của input bằng phép chia dư cho 10, nhân reverse với 10 rồi cộng chữ số vừa lấy vào, sau đó chia input cho 10 để loại bỏ chữ số cuối và lặp lại cho đến khi input bằng 0
// ============================================================

// Khai báo thư viện
.extern printf
.extern scanf

// Vùng data khai báo thông báo với  format số integer
.section .data
    tb1: .asciz "Please enter number n:\n"
    tb2: .asciz "Palindrome  Number \n"
    tb3: .asciz "Not a Palindrome  Number \n"
    tb4: .asciz "Invalid Number \n"
    fmt_in: .asciz "%ld"

// Khai báo biến số n
.section .bss 
    n: .space 8

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


    // Kiểm tra số âm
    CMP X19, #0
    B.LT INVALID_INPUT

    // Lưu giá trị ban đầu xài cho so sánh
    ADD X20, X19, XZR

    // Tạo biến reverse ban đầu bằng 0
    MOVZ X21, #0

    // Tạo biến số 10
    MOVZ X22, #10

    LOOP:
        // Kết thúc khi input sau khi xử lý = 0
        CMP X19, #0
        B.EQ CHECK

        // Lấy input chia cho 10
        UDIV X23, X19, X22

        // Tính digit = input - (X23 * 10)
        MUL X24, X23, X22
        SUB X25, X19, X24

        // reverse = reverse * 10 + digit
        MUL X21, X21, X22
        ADD X21, X21, X25

        // input giờ bằng phần nguyên đã chia cho 10
        ADD X19, X23, XZR

        B LOOP

CHECK:
    // so sánh số lưu ban đầu X20 với số reverse X21
    CMP X20, X21
    B.EQ PALINDROME
    B NOT_PALINDROME

    

PALINDROME:
    ADRP X0, tb2
    ADD X0, X0, :lo12:tb2
    BL printf
    B EXIT

NOT_PALINDROME:
    ADRP X0, tb3
    ADD X0, X0, :lo12:tb3
    BL printf
    B EXIT

INVALID_INPUT:
    ADRP X0, tb4
    ADD X0, X0, :lo12:tb4
    BL printf
    B EXIT
EXIT:
    MOV  X0, #0
    MOV X8, #93
    SVC #0
