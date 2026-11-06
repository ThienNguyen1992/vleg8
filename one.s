
// ============================================================
// Bài 1 – Kiểm tra số nguyên tố
// Số nguyên tố là số chỉ chia cho 1 và chính nó
// Cách làm là
// + In ra màn hình yêu cầu nhập số nguyên tố
// + Nếu nhập chữ: báo lỗi + bắt nhập lại
// + Nhập số < 0 báo lỗi
// + Nếu số là 0, 1 => báo no
// + Nếu là 2,3  báo đúng
// + Lặp vòng lặp bắt đầu từ 2 lấy input trừ cho default 2 trừ dần dến hết nếu khác 0 thì Yes, là 0 thì là No. 
// Nếu Yes tăng thêm 3, 4,5.... đến khi nào bằng input thì dừng
// vì không có phép chia tìm số dư nên xài phép trừ thay cho phép chia
// ============================================================

// Khai báo thư viện
.extern printf
.extern scanf


// Vùng data khai báo thông báo với  format số integer
.section .data
    tb1: .asciz "Please enter number n:\n"
    tb2: .asciz "Yes"
    tb3: .asciz "No"
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

// kiểm tra số âm
CMP X19, #0
B.LT INVALID_INPUT

// kiểm tra n = 0 hoặc n = 1
CMP X19, #1
B.LE NOT_PRIME

// kiểm tra n = 2 hoặc 3 thì báo kết quả là số nguyên tố

CMP X19, #2
B.EQ IS_PRIME

CMP X19, #3
B.EQ IS_PRIME

// Gán biến con chạy
MOVZ X20, #2

CHECK_PRIME:
    // cho biến chạy X19 , nếu X19 lớn hơn hoặc bằng X20 thì là số nguyên tố do không chia được cho số nào khác
    CMP X20, X19
    B.GE IS_PRIME

    // Gán biến tạm 

    MOV X21, X19

IS_DIVIDE_ZERO:
    // Nếu X21 nhỏ hơn input thi chạy tiếp
    CMP X21, X20
    B.LT GO_NEXT

    // Dựa vào biến con chạy và trừ
    // ví dụ X21 = 2 thì lần lượt trừ cho 2
    // nếu X21 là 3 thì trừ cho 3. nếu X21 không có phần = 0 thìlà prime
    SUB X21, X21, X20
    B IS_DIVIDE_ZERO

GO_NEXT:
     // Nếu phần dư bằng 0 => không phải số nguyên tố
    CMP X21, #0
    B.EQ NOT_PRIME

    // không phải thì cộng thêm 1
    ADDI X20, X20, #1
    B CHECK_PRIME

// in thông báo là số không hợp lệ
INVALID_INPUT:
    ADRP X0, tb4
    ADD X0, X0, :lo12:tb4
    BL printf
    B EXIT

// in không phải số nguyên tố
NOT_PRIME:
    ADRP X0, tb3
    ADD X0, X0, :lo12:tb3
    BL printf
    B EXIT

IS_PRIME:
    ADRP X0, tb2
    ADD X0, X0, :lo12:tb2
    BL printf
    B EXIT

EXIT: 
    MOV  X0, #0
    MOV X8, #93
    SVC #0