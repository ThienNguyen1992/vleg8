
// ============================================================
// Bài 5 – Xử lý mảng số nguyên (sử dụng kỹ thuật hàm)
// 
// Cách làm
// - 5.1: Nhập và lưu mảng 1 chiều n phần tử (kiểm tra n từ 1 đến 100)
// - 5.2: Xuất toàn bộ mảng ra màn hình
// - 5.3: Viết hàm kiểm tra số nguyên tố (tái sử dụng từ Bài 1), duyệt mảng và in danh sách SNT
// - 5.4: Tìm giá trị lớn nhất (khởi tạo max = a[0], so sánh cập nhật qua từng phần tử)
// - 5.5: Tính tổng và tính trung bình cộng các phần tử (chia nguyên)
// ============================================================
// Khai báo thư viện
.extern printf
.extern scanf

// Vùng data khai báo thông báo với  format số integer
.section .data
    tb1: .asciz "Please enter number n(1-100):\n"
    tb2: .asciz "Enter arr[%ld]:"

    // 1.
    tb3: .asciz "\n ========================= 1. Print Array =======================\n"
    tb4: .asciz "%ld"
    tb4a: .asciz "["
    tb4b: .asciz ","
    tb4c: .asciz "]\n"
    tb5: .asciz "\n"

    // 2.
    tb6: .asciz "\n========== 2. Print Prime Number ==========\n"
    tb7: .asciz "Prime list: "
    tb8: .asciz "Not include Prime numbers.\n"

    // 3.
    tb9: .asciz "\n========== 3. Print Largest Number ==========\n"
    tb10: .asciz "Largest number : %ld\n"

    // 4.
    tb11: .asciz "\n========== 4. Average ==========\n"
    tb12: .asciz "Average is %ld\n"

    // Thong bao loi (dat sau cac chuc nang)
    tb13: .asciz "Invalid input! Please enter an integer.\n"
    tb14: .asciz "Invalid n! n must be between 1 and 100.\n"
    tb15: .asciz "Invalid array element! Number must be >= 0.\n"

    // Dinh dang (Format)
    fmt_in:  .asciz "%ld"
    fmt_out: .asciz "%ld "

// Khai báo biến số n
.section .bss 
    .balign 8
    n: .space 8
    arr: .space 800


.section .text
.global main


main:

   // Lưu X19 va X30 vao Stack
    SUB SP, SP, #32
    STUR X19, [SP, #0]
    STUR X20, [SP, #8]
    STUR X21, [SP, #16]
    STUR X30, [SP, #24]

// ------------------------------------------------------------
// 1. In thông báo nhập số n
// ------------------------------------------------------------
    ADRP X0, tb1
    ADD  X0, X0, :lo12:tb1
    BL   printf

    MOVZ X0, #0
    BL fflush

// Nhập số nguyên n
    ADRP X0, fmt_in  // gán địa chỉ fmt_in vào thanh ghi X0
    ADD X0, X0, :lo12:fmt_in // lấy 12 bit cuối gán vô X0 cho đầy dủ


// tương tụ
    ADRP X1, n  
    ADD X1, X1, :lo12:n

    Bl scanf

    // Kiểm tra số nhập vào phải đúng format không
    CMP W0, #1
    B.NE INVALID_INPUT


    // Kiểm tra n 1 tới 100
    ADRP X21, n
    ADD X21, X21, :lo12:n
    LDUR X21, [X21, #0]


    // n >= 1
    MOVZ X22, #1
    CMP X21, X22
    B.LT INVALID_INPUT

    // n <= 100
    MOVZ X22, #100
    CMP X21, X22
    B.GT N_ERROR

    // Khởi tạo mảng
    // X19 là i
    // X20 là arr[i]
    // X21  là n

    // gán i = 0
    MOVZ X19, #0

    // Địa chỉ ban đầu arr[0]
    ADRP X20, arr
    ADD X20, X20, :lo12:arr

    // Nhập phần tử vô mảng
    LOOP_IN:
        // i >= n dừng 
        CMP X19, X21
        B.GE DONE

        // In thông báo nhập arr[i]
        ADRP X0, tb2
        ADD X0, X0, :lo12:tb2

        MOV X1, X19
        BL printf

        MOVZ X0, #0
        BL fflush

        // Nhập arr[i]
        // scanf vô

        ADRP X0, fmt_in
        ADD X0, X0, :lo12:fmt_in

        MOV X1, X20
        BL scanf

        // Kierm tra nhập số
        CMP W0, #1
        B.NE INVALID_INPUT


        //  kiểm tra lớn hơn không
        LDUR X9, [X20, #0]

        CMP X9, #0
        B.LT ARRAY_ERROR

        // Tăng kích thước lên 8byte cho phần tư tiếp theo
        ADD X20, X20, #8

        // tăng chỉ số i lên 
        ADD X19, X19, #1
        B LOOP_IN

        // Xuất các phần tử ra

        LOOP_OUT:
            // i < n, dừng
            CMP X19, X21
            B.GE DONE_OUT

            // Phần tử đầu không có dấu phẩy
            CMP X19, #0
            B.EQ PRINT_NUM

            ADRP X0, tb4b
            ADD X0, X0, :lo12:tb4b
            BL printf

        PRINT_NUM:
            // Đọc arr[i]
            LDUR X1, [X20, #0]

            // in arr[i]
            ADRP X0, tb4
            ADD X0, X0, :lo12:tb4
            BL printf

            // tăng lên 8 byte
            ADD X20, X20, #8

            // tăng lên 1 con biến chạy
            ADD X19, X19, #1

            B LOOP_OUT

DONE_OUT:
    ADRP X0, tb4c
    ADD X0, X0, :lo12:tb4c
    BL printf

    B PRIME_SECTION

// làm ở câu 1
PRIME_SECTION:
    ADRP X0, tb6
    ADD X0, X0, :lo12:tb6
    BL printf

    ADRP X0, tb7
    ADD X0, X0, :lo12:tb7
    BL printf

    MOVZ X19, #0
    MOVZ X22, #0

    ADRP X20, arr
    ADD X20, X20, :lo12:arr

PRIME_LOOP:
    CMP X19, X21
    B.GE PRIME_DONE

    LDUR X0, [X20, #0]

    BL IS_PRIME

    CMP X0, #0
    B.EQ PRIME_NEXT

    LDUR X1, [X20, #0]

    ADRP X0, fmt_out
    ADD X0, X0, :lo12:fmt_out
    BL printf

    ADD X22, X22, #1

PRIME_NEXT:
    ADD X20, X20, #8
    // Tăng i
    ADD X19, X19, #1
    B PRIME_LOOP

PRIME_DONE:
    CMP X22, #0
    B.NE MAX_SECTION

    ADRP X0, tb8
    ADD X0, X0, :lo12:tb8
    BL printf




IS_PRIME:
    CMP X0, #2
    B.LT NOT_PRIME

    MOV X10, X0

    MOVZ X9, #2

CHECK_PRIME:
    CMP X9, X10
    B.GE IS_PRIME_RESULT

    MOV X11, X10

IS_DIVIDE_ZERO:
    CMP X11, X9
    B.LT GO_NEXT

    SUB X11, X11, X9
    B IS_DIVIDE_ZERO

GO_NEXT:
    CMP X11, #0
    B.EQ NOT_PRIME

    ADD X9, X9, #1
    B CHECK_PRIME

IS_PRIME_RESULT:
    MOVZ X0, #1
    BR X30

NOT_PRIME:
    MOVZ X0, #0
    BR X30

INVALID_INPUT:
    ADRP X0, tb13
    ADD X0, X0, :lo12:tb13
    BL printf
    B EXIT

// lỗi n không trong khoảng 1 -100
N_ERROR:
    ADRP X0, tb14
    ADD X0, X0, :lo12:tb14
    BL printf
    B EXIT

DONE:
    ADRP X0, tb3
    ADD X0, X0, :lo12:tb3
    BL printf

    MOVZ X0, #0
    BL fflush

    MOVZ X19, #0
    ADRP X20, arr
    ADD X20, X20, :lo12:arr

    ADRP X0, tb4a
    ADD X0, X0, :lo12:tb4a
    BL printf
    B LOOP_OUT

ARRAY_ERROR:
    ADRP X0, tb15
    ADD X0, X0, :lo12:tb15
    BL printf
    B EXIT

MAX_SECTION:
    // In tiêu đề
    ADRP X0, tb9
    ADD X0, X0, :lo12:tb9
    BL printf

    // Khởi tạo max = arr[0]
    ADRP X20, arr
    ADD X20, X20, :lo12:arr

    LDUR X22, [X20, #0]

    // i = 1
    MOVZ X19, #1

    // Đến arr[1]
    ADD X20, X20, #8

MAX_LOOP:
    // Nếu i >= n, dừng
    CMP X19, X21
    B.GE MAX_DONE

    // Lay arr[i]
    LDUR X9, [X20, #0]

    // Nếu arr[i] <= max thì bỏ qua
    CMP X9, X22
    B.LE MAX_NEXT

    // cập nhật max cho arr[i]
    MOV X22, X9

MAX_NEXT:
    // Tăng địa chỉ cho phần tư
    ADD X20, X20, #8

    // Tăng i
    ADD X19, X19, #1

    B MAX_LOOP

MAX_DONE:
    // In giá trị lớn nhất
    ADRP X0, tb10
    ADD X0, X0, :lo12:tb10

    MOV X1, X22
    BL printf

    B AVERAGE_SECTION

AVERAGE_SECTION:
    // In tiêu đề
    ADRP X0, tb11
    ADD X0, X0, :lo12:tb11
    BL printf

    // Khởi tạo sum = 0
    MOVZ X22, #0

    // Biến chạy = 1
    MOVZ X19, #0

    // LẤy địa chỉ arr[0]
    ADRP X20, arr
    ADD X20, X20, :lo12:arr

AVERAGE_LOOP:
    // nếu i > = n, dừng
    CMP X19, X21
    B.GE AVERAGE_DONE

    // Lấy  arr[i]
    LDUR X9, [X20, #0]

    // sum = sum + arr[i]
    ADD X22, X22, X9

    // tăng 8 byte chi địa chỉ 
    ADD X20, X20, #8

    // tăng i
    ADD X19, X19, #1

    B AVERAGE_LOOP

AVERAGE_DONE:
    // average = sum / n
    SDIV X23, X22, X21

    // In kết quả
    ADRP X0, tb12
    ADD X0, X0, :lo12:tb12

    MOV X1, X23
    BL printf

    B EXIT

EXIT:
    MOVZ X0, #0
    BL fflush
    MOV  X0, #0
    MOV X8, #93
    SVC #0


