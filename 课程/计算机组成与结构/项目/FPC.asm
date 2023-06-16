# This is a floating point calculator（FPC） that supports addition, subtraction, multiplication and division of two input floating point numbers and returns the results in binary and hexadecimal formats.
.data 
	msg_welcome: 		.asciiz "\nHello!I am a floating point calculator that can menu addition, subtraction, multiplication and division.\nPlease follow the instructions and input numbers to use me.\n" 
	msg_menu:		.asciiz "\nMenu\n1: +    2: -    3: ×    4: ÷   5: Exit\nChoose:"
	msg_exit:		.asciiz "\nThanks for your using. Bye bye!\n"
	msg_first_float:	.asciiz "\nFirst floating-point value:"
	msg_sencond_float:	.asciiz "\nSecond floating-point value:"
	msg_invalid_input:	.asciiz "\nInvalid input!\n"
	msg_print_bin:		.asciiz "\nBinary result:\n"
	msg_print_hex: 		.asciiz "\nHexadecimal result:\n"
	error_over_flow:	.asciiz "\nError: overflow!\n"
	error_under_flow:	.asciiz "\nError: underflow!\n"
	error_div_zero:		.asciiz "\nError: Cannot divde by zero!\n"
	hex_table:  		.asciiz "0123456789ABCDEF"
	hex_digits: 		.asciiz "XXXXXX"
	string_neg:		.asciiz "-"
	string_1dot:		.asciiz "1."
	string_0dot:		.asciiz "0."
	string_totwo:		.asciiz "*2^"
	string_to16:		.asciiz "*16^"
	string_0:		.asciiz "0"
	string_1: 		.asciiz "1"
	string_hex0: 		.asciiz "000000*16^0"

.text
# --    欢迎    --
welcome:
    	la      $a0,    msg_welcome      # 输出欢迎语
    	li      $v0,    4                # 打印字符串
    	syscall                        
    	j       menu                     # 跳转到menu


# --    功能菜单    --
menu:
    	la      $a0,    msg_menu          # 输出菜单提示消息
    	li      $v0,    4                 # 打印字符串
    	syscall                        
    	# 读取用户的输入
    	li      $v0,    5                 # 读取整数
    	syscall                        
   	move    $v1,    $v0               # 将输入值存入$v1
    	j       branch                    # 跳转到branch

branch:
    	beq     $v1,    1,    read_float  # 如果输入值为1，跳转到read_float
    	beq     $v1,    2,    read_float  # 如果输入值为2，跳转到read_float
    	beq     $v1,    3,    read_float  # 如果输入值为3，跳转到read_float
    	beq     $v1,    4,    read_float  # 如果输入值为4，跳转到read_float
    	beq     $v1,    5,    exit        # 如果输入值为5，跳转到exit
    	# 其他的输入则提示输入错误，重新输入
    	la      $a0,    msg_invalid_input  # 输出输入错误提示消息
    	li      $v0,    4                  # 打印字符串
    	syscall                           

    	j       menu                       # 跳转到menu

read_float:
    	# 读取第一个浮点数
    	la      $a0,    msg_first_float     # 输出第一个浮点数提示消息
    	li      $v0,    4                   # 打印字符串
    	syscall                           

    	li      $v0,    6                   # 读取浮点数
    	syscall                           

    	mfc1    $t0,    $f0                 # 将浮点数存入$t0寄存器

    	srl     $s0,    $t0,    31          # 保存第一个浮点数的符号至$s0
    
    	sll     $s1,    $t0,    1		# 保存第一个浮点数的指数至$s1
    	srl     $s1,    $s1,    24	  					
    	sll     $s2,    $t0,    9		# 保存第一个浮点数的尾数至$s2
    	srl     $s2,    $s2,    9
    	addi    $s2,    $s2,    0x00800000	# 尾数补前导位1 16进制数

    	# 读取第二个浮点数
    	la      $a0,    msg_sencond_float   # 输出第二个浮点数提示消息
    	li      $v0,    4                   # 打印字符串
    	syscall                           

    	li      $v0,    6                   # 读取浮点数
    	syscall                           

    	mfc1    $t0,    $f0                 # 将浮点数存入$t0寄存器
    	srl     $s3,    $t0,    31          # 保存第二个浮点数的符号至$s3
    	sll     $s4,    $t0,    1	    # 保存第二个浮点数的指数至$s4
    	srl     $s4,    $s4,    24   
   	sll     $s5,    $t0,    9	     # 保存第二个浮点数的尾数至$s5
    	srl     $s5,    $s5,    9
    	addi    $s5,    $s5,    0x00800000  # 尾数补前导位1 16进制数

    	beq     $v1,    1,    add            # 如果输入值为1，跳转到add
    	beq     $v1,    2,    sub            # 如果输入值为2，跳转到sub
    	beq     $v1,    3,    multiply       # 如果输入值为3，跳转到multiply
    	beq     $v1,    4,    divide         # 如果输入值为4，跳转到divide

    	la      $a0,    msg_invalid_input   # 加载输入错误提示消息
    	li      $v0,    4                   # 打印字符串
    	syscall                           

    	j       menu                        # 跳转到menu

	
# --	加法    --
add:                                		
	sub	$t0,	$s1,	$s4              # 计算两个指数的差
	bltz	$t0,	adjust_first_operand             # 如果差值为负，跳转到 adjust_first_operand
	bgtz	$t0,	adjust_second_operand            # 如果差值为正，跳转到 adjust_second_operand
	beq	$t0,	$0,	judge_sign       # 如果差值为零，跳转到 judge_sign

	adjust_first_operand:                            # 对第一个数进行调整
		addi	$s1,	$s1,	1        # 指数加1
		srl	$s2,	$s2,	1        # 尾数右移1位
		j	add                      # 跳回 add 重新进行计算
	
	adjust_second_operand:                           # 对第二个数进行调整
		addi	$s4,	$s4,	1        # 指数加1
		srl	$s5,	$s5,	1        # 尾数右移1位
		j	add                	 # 跳回 add 重新进行计算

	judge_sign:                              # 符号判断
		xor	$t3,	$s0,	$s3      # 对两个符号进行异或操作，结果存放在$t3中
		beq	$t3,	0,	same_sign    # 如果两符号相同，跳转到 same_sign
		beq	$t3,	1,	diff_sign    # 如果两符号不同，跳转到 diff_sign

	same_sign:                             # 符号相同的情况
		add	$t3,	$s2,	$s5      # 尾数相加
		move	$t2,	$s1      	 # 将指数移动到$t2
		move	$t1,	$s0     	 # 将符号移动到$t1
		bge	$t3,	0x01000000,	carry    # 如果尾数加法后进位，跳转到 carry
		j	print_result          	 # 否则直接输出结果

	diff_sign:                       	 # 符号不同的情况
		move	$t2,	$s1      	 # 将指数移动到$t2
		sub	$t3,	$s2,	$s5      # 尾数相减
		bgtz	$t3,	first_operand_bigger        # 如果差值为正，跳转到 first_operand_bigger
		bltz	$t3,	second_operand_bigger       # 如果差值为负，跳转到 second_operand_bigger
		beq	$t3,	$0,	print_zero   # 如果差值为零，输出0

	first_operand_bigger:                               # 第一个数大的情况
		move	$t1,	$s0              # 将符号移动到$t1
		j 	adjust_sub   		 # 跳转到 adjust_sub进行调整

	second_operand_bigger:                              # 第二个数大的情况
		move	$t1,	$s3      	 # 将符号移动到$t1
		sub	$t3,	$s5,	$s2      # 将尾数相减
		j 	adjust_sub    		 # 跳转到 adjust_sub进行调整

	adjust_sub:                              # 进行尾数调整
		blt	$t3,	0x00800000,	adjust_sub1    # 如果尾数小于0x00800000，跳转到 adjust_sub1
		j	print_result   		 # 否则直接输出结果

	adjust_sub1:                             # 进行尾数调整1
		beq	$t2,	0,	error_underflow    # 如果指数为0，抛出下溢错误
		addi	$t2,	$t2,	-1    	 # 指数减1
		sll	$t3,	$t3,	1   	 # 尾数左移1位
		blt	$t3,	0x00800000,	adjust_sub1   # 如果尾数小于0x00800000，继续调整
		j	print_result    		 # 否则直接输出结果

	carry:                                   # 进位处理
		beq	$t2,	255,	error_overflow    # 如果指数为255，抛出上溢错误
		srl	$t3,	$t3,	1    	 # 尾数右移1位
		addi	$t2,	$t2,	1    	 # 指数加1
		j	print_result    		 # 输出结果


# --	减法    --
sub:
	xori   	$s3,     $s3,    0x00000001	# 对第二个浮点数符号进行取反
	j	add	# 然后执行加法


# --	乘法    --
multiply:                                 
	beq	$s1, 	0, 	mult_first_exp_zero    # 如果第一个操作数的指数为0，跳转到mult_first_exp_zero
	beq	$s4, 	0, 	mult_second_exp_zero   # 如果第二个操作数的指数为0，跳转到mult_second_exp_zero
	j	mult_operands_nonzero                       # 如果两个操作数的指数都不为0，跳转到mult_operands_nonzero
	
	mult_first_exp_zero:                           # 第一个操作数指数为0的处理过程
   		beq     $s2,   0x800000,	mult_operand_has_zero     # 如果第一个操作数的尾数为最大值，跳转到mult_operand_has_zero
    		beq     $s4,   0,  	mult_second_exp_zero   # 如果第二个操作数的指数为0，跳转到mult_second_exp_zero
    		j       mult_operands_nonzero               # 如果以上都不满足，跳转到mult_operands_nonzero

	mult_second_exp_zero:                          # 第二个操作数指数为0的处理过程
    		beq     $s5,   0x800000,	mult_operand_has_zero	# 如果第二个操作数的尾数为最大值，跳转到mult_operand_has_zero
    		j       mult_operands_nonzero               # 如果不满足，跳转到mult_operands_nonzero

	mult_operand_has_zero:                             # 操作数中存在0的处理过程
    		li      $t1,   0                 # 设置结果的符号为0
    		li	$t2,   0                 # 设置结果的指数为0
   	 	li      $t3,   0                 # 设置结果的尾数为0
    		j       multiply_end             # 跳转到multiply_end结束此过程

	mult_operands_nonzero:                              # 两个操作数都不为0的处理过程
    		add	$t2,   $s1,   $s4        # 指数部分相加
    		li      $t4,   127               # 设置一个中间变量$t4为常数127
    		sub     $t2,   $t2,   $t4        # 指数相加的结果减去127，得到新的指数

    		mult    $s2,   $s5               # 尾数部分相乘
    		mfhi    $t3    			 # 取乘法结果的高位，HI: 16位0, 2位整数部分, 14位小数部分
    		mflo    $t4    			 # 取乘法结果的低位，LO: 32位小数剩余部分                  
    		sll     $t3,   $t3,   9	         # 将高位左移9位
    		srl     $t4,   $t4,   23	 # 将低位右移23位
    		or      $t3,   $t3,   $t4        # 高位和低位进行逻辑或操作，得到新的尾数

    	# 归一化
   	srl     $t4,   $t3,   24                 # 将尾数右移24位，取得第25位
    	beq     $t4,   $0,   after_norm          # 如果第25位为0，跳过归一化过程
    	srl     $t3,   $t3,   1                  # 将尾数右移一位
   	addi    $t2,   $t2,   1                  # 指数加1，完成归一化

	after_norm:
    		slti    $t4,   $t2,   0          # 如果指数小于0，$t4为1，否则为0
    		beq     $t4,   1,       error_underflow	# 如果$t4为1，表示指数下溢，跳转到error_underflow处理过程
    		li      $t4,   255           	 # 设置$t4为常数255
    		slt     $t4,   $t4,   $t2        # 如果$t4小于$t2，$t4为1，否则为0
    		beq     $t4,   1,       error_overflow    # 如果$t4为1，表示指数上溢，跳转到error_overflow处理过程
    		xor     $t1,   $s0,   $s3        # 对两个操作数的符号位进行异或操作，得到结果的符号位
    		j       multiply_end             # 跳转到multiply_end结束此过程

	multiply_end:                            # 乘法过程结束
    		j       print_result                   # 跳转到输出


	
# --	除法    --
divide:                                          # 定义除法过程
	beq	$s1, 	0, 	div_first_exp_zero     # 如果被除数的指数为0，跳转到div_first_exp_zero
	j	div_operands_nonzero                        # 如果被除数的指数不为0，跳转到div_operands_nonzero

	div_first_exp_zero:                            # 被除数指数为0的处理过程
    		beq         $s2,     0x800000, div_first_operand_zero     # 如果被除数的尾数为最大值，跳转到div_first_operand_zero
    		j           div_operands_nonzero            # 如果被除数的尾数不为最大值，跳转到div_operands_nonzero

	div_first_operand_zero:                            # 被除数为0的处理过程
    		li          $t1,     0           # 设置结果的符号为0
    		li          $t2,     0           # 设置结果的指数为0
    		li          $t3,     0           # 设置结果的尾数为0
    		j           div_end              # 跳转到div_end结束此过程

	div_operands_nonzero:                               # 被除数不为0的处理过程
    		bne         $s4,     0,           normal    # 如果除数的指数不为0，跳转到normal
    		bne         $s5,     0x800000, normal        # 如果除数的尾数不为最大值，跳转到normal
    		j           error_divided_by_zero     # 如果除数为0，跳转到error_divided_by_zero处理过程

	normal:                                  # 正常的处理过程
    		sub         $t2,     $s1,     $s4       # 指数部分相减
   		addi        $t2,     $t2,     127       # 结果加上常数127，得到新的指数
    		xor         $t1,     $s0,     $s3       # 对两个操作数的符号位进行异或操作，得到结果的符号位
    		div         $s2,     $s5                # 尾数部分相除
    		mflo        $t3                         # 取除法结果的低位，作为结果的尾数的整数部分
    		mfhi        $t4                         # 取除法结果的高位，作为新的尾数
   		beq         $t3,     $0,     div_end    # 如果结果的尾数为0，跳转到div_end结束此过程
    		li          $t5,     1                  # 设置一个中间变量$t5为1

	div_loop1:                                      # 第一个循环，确定整数部分的位数
    		srlv        $t6,     $t3,     $t5       # 将尾数右移$t5位
    		bne         $t6,     $0,     div_loop1  # 如果右移后的尾数不为0，继续循环
    		li          $t6,     1                  # 设置一个中间变量$t6为1
    		sub         $t5,     $t5,     $t6       # 将$t5减去1，得到新的$t5
    		add         $t2,     $t2,    $t5        # 指数部分加上$t5，得到新的指数
    		slti        $t4,     $t2,     0         # 如果新的指数小于0，$t4为1，否则为0
    		beq         $t4,     1,        error_underflow     # 如果$t4为1，表示指数下溢，跳转到error_underflow处理过程
    		li          $t4,     255                # 设置$t4为常数255
    		slt         $t4,     $t4,     $t2       # 如果$t4小于$t2，$t4为1，否则为0
    		beq         $t4,     1,        error_overflow       # 如果$t4为1，表示指数上溢，跳转到error_overflow处理过程
    		li          $t7,     23                 # 设置一个中间变量$t7为23
    		sub         $t7,     $t7,     $t5       # 将$t7减去$t5，得到新的$t7
    		li          $t6,     0                  # 设置一个中间变量$t6为0

	div_loop2:                                      # 第二个循环，计算小数部分的位数
    		sll         $t4,     $t4,     1         # 将尾数左移1位
    		div         $t4,     $s5                # 将新的尾数除以除数
    		mflo        $t8                         # 取除法结果的低位，作为新的尾数
    		mfhi        $t4                         # 取除法结果的高位，作为新的尾数
    		sll         $t3,     $t3,     1         # 将结果的尾数左移1位
    		add         $t3,     $t3,     $t8       # 将新的尾数加到结果的尾数上，得到新的尾数
    		addi        $t6,     $t6,     1         # 将计数器$t6加1
    		beq         $t6,     $t7,     div_end   # 如果计数器等于$t7，跳转到div_end结束此过程
    		beq         $t4,     $0,     div_comp_dec	# 如果新的尾数为0，跳转到div_comp_dec
    		j           div_loop2                   # 否则，继续循环

	div_comp_dec:                                   # 尾数为0时的处理过程
    		sub         $t6,     $t7,     $t6       # 将$t7减去$t6，得到新的$t6
    		sllv        $t3,     $t3,     $t6       # 将结果的尾数左移$t6位，得到新的尾数

	div_end:                                        # 除法结束
    		j           print_result                      # 跳转到print_result输出结果


# --	错误信息输出    --
error_divided_by_zero:
	la          $a0,    error_div_zero       # 被零除错误消息
    	li          $v0,    4                  # 打印字符串
   	syscall                               
    	j           exit                       # 跳转到程序结束

error_overflow:
    	la          $a0,    error_over_flow      # 溢出错误消息
    	li          $v0,    4                  # 打印字符串
    	syscall                              
    	j           exit                       # 跳转到程序结束

error_underflow:
    	la          $a0,    error_under_flow     # 下溢错误消息
    	li          $v0,    4                  # 打印字符串
    	syscall                               
    	j           exit                       # 跳转到程序结束


# --	输出结果    --
print_zero:				       # 输出0
    	move        $a0,    $0                  
    	li          $v0,    1                  # 打印整数
    	syscall                               
    	li          $v0,    11                 # 换行
    	li          $a0,    '\n'
    	syscall                              
    	j           menu                  # 跳转到计算过程

print_result:					       # 输出计算结果
    	li          $v0,    4                  # 打印字符串
    	la          $a0,    msg_print_bin     # 结果二进制消息
   	syscall                              

    	# 判断结果是否为0
    	beq         $t1,    0,    check_bin_exp_zero   # 如果结果符号位为0，跳转到check_bin_exp_zero
    	j           print_bin_not_zero               # 否则跳转到print_bin_not_zero

check_bin_exp_zero:
    	beq         $t2,    0,    print_bin_zero   # 如果结果指数为0，跳转到print_bin_zero
    	j           print_bin_not_zero               # 否则跳转到print_bin_not_zero

print_bin_zero:
    	la          $a0,    string_0dot        # "0."
    	syscall                              

    	move        $a1,    $t3                 # 将结果尾数存入$a1
    	li          $a2,    22                  # 设置打印位数为22
    	jal         print_bits                   # 打印结果尾数

    	la          $a0,    string_totwo        # "*2^"
    	syscall                              

    	move        $a0,    $t2                 # 结果指数存入$a0
    	li          $v0,    1                   # 打印整数
    	syscall                              

    	jal         print_bin_end                    # 跳转到二进制输出结束
    	j           menu                 # 跳转到计算过程

print_bin_not_zero:
    	beq         $t1,    0,       skipBinNeg   # 如果结果符号位为0，跳过负号
    	la          $a0,    string_neg          # "-"
	syscall                              

    	skipBinNeg:
    		la          $a0,    string_1dot         # "1."
   		syscall                              

    		move        $a1,    $t3                 # 将结果尾数存入$a1
    		li          $a2,    22                  # 设置打印位数为22
    		jal         print_bits                   # 打印结果尾数

    		la          $a0,    string_totwo        # "*2^"
    		syscall                              

    		addi        $a0,    $t2,    -127        # 结果指数减去127
    		li          $v0,    1                   # 打印整数
    		syscall                              

    		jal         print_bin_end                    # 跳转到二进制输出结束
    		j           menu                 # 跳转到计算过程

print_bin_end:
    	li          $v0,    4                   # 打印字符串
    	la          $a0,    msg_print_hex      # 结果十六进制消息
    	syscall                              

    	beq         $t1,    0,       check_hex_exp_zero   # 如果结果符号位为0，跳转到check_hex_exp_zero
    	j           print_hex_not_zero                # 否则跳转到print_hex_not_zero

check_hex_exp_zero:
    	beq         $t2,    0,       print_hex_zero   # 如果结果指数为0，跳转到print_hex_zero
    	j           print_hex_not_zero                # 否则跳转到print_hex_not_zero

print_hex_zero:
    	la          $a0,    string_0dot         # "0."
    	syscall                              

    	la          $a0,    string_hex0         # "000000*16^0"
    	syscall                              

    	j           print_hex_end                  # 跳转到十六进制输出结束

print_hex_not_zero:
	lw	    $t1,	28($sp)		#取出结果符号位
    	beq         $t1,    0,       skipHexoutNeg  # 如果结果符号位为0，跳过负号
    	la          $a0,    string_neg          # "-"
    	syscall                              

    	skipHexoutNeg:
    		addi        $t7,    $t2,    -127        # 结果指数减去127
    		bltz        $t7,    hex_exp_negative    # 如果结果指数小于0，跳转到hex_exp_negative

    		andi        $t4,    $t7,    0x3         # 取结果指数除以4的余数，存入$t4
    		srl         $t5,    $t7,    2           # 取结果指数除以4的商，存入$t5
    		j           prepare_hex_output          # 跳转到prepare_hex_output

hex_exp_negative:
    	li          $t4,    0                   # 初始化计数器$t4
    	move        $t6,    $7                  # 将计数器$t6初始化为23

hex_out_loop:
    	andi        $t7,    $t6,    0x3         # 取计数器$t6除以4的余数，存入$t7
    	beq         $t7,    0,       hex_out_loopEnd 	# 如果余数为0，跳转到hex_out_loopEnd
    	addi        $t6,    $t6,    -1          # 计数器$t6减1
    	addi        $t4,    $t4,    1           # 计数器$t4加1
    	j           hex_out_loop                 # 继续循环

hex_out_loopEnd:
    	srl         $t5,    $t6,    2           # 取计数器$t6除以4的商，存入$t5

prepare_hex_output:
   	 li         $t7,    23                  # 设置中间变量$t7为23
    	sub         $t6,    $t7,    $t4         # 将$t7减去$t4，得到新的$t6
    	srlv        $t6,    $t3,    $t6         # 将结果尾数右移$t6位

    	# 输出小数点前部分
    	move        $a0,    $t6                 # 将新的尾数存入$a0
    	li          $a1,    0                   # 设置$a1为0
    	jal         convert_to_hex              # 跳转到convert_to_hex

    	# "."
   	li          $v0,    11                  # 打印字符
    	la          $a0,    '.'          	# "."
    	syscall                              

    	addi        $t6,    $t4,    9           # 计算小数点后的位数
    	sllv        $t6,    $t3,    $t6         # 将结果尾数左移$t6位

    	# 输出尾数
   	move        $a0,    $t6                 # 将新的尾数存入$a0
    	li          $a1,    1                   # 设置$a1为1
    	jal         convert_to_hex                     # 跳转到convert_to_hex

    	# "*16^"
    	li          $v0,    4                   # 打印字符串
    	la          $a0,    string_to16         # "*16^"
    	syscall                              

    	# 输出t5
    	li          $v0,    1                   # 打印整数
    	move        $a0,    $t5                 # 将新的尾数存入$a0
    	syscall                              

print_hex_end:
    	li          $v0,    11                  # 换行
    	li          $a0,    '\n'
    	syscall                              

    	j           menu                 	# 跳转到计算过程


print_bits: 					# 要显示的内容存在a1，从第a2位（0开始）开始输出
    	addi        $sp,    $sp,    -32         # 分配栈空间
    	sw          $t1,    28($sp)             # 保存寄存器$t1
   	sw          $t6,    24($sp)             # 保存寄存器$t6
    	sw          $ra,    20($sp)             # 保存返回地址
    	sw          $fp,    16($sp)             # 保存帧指针
    	addiu       $fp,    $sp,    28          # 设置新的帧指针
    
    	move        $t6,    $a2                 # 将startIndex存入$t6
    	li          $v0,    4                   # 打印字符串

bit_shift_loop:
    	srlv        $t1,    $a1,    $t6         # 将内容右移$t6位，存入$t1
    	andi        $t1,    $t1,    0x1         # 取$t1的最低位，存入$t1
    	beqz        $t1,    print_zero_bit                 # 如果最低位为0，跳转到print_zero
    	j           print_one_bit                        # 否则跳转到print_one

print_zero_bit:
    	la          $a0,    string_0            # "0"
    	j           print_bin                   # 打印0

print_one_bit:
    	la          $a0,    string_1            # "1"
    	j           print_bin                   # 打印1

print_bin:
    	syscall                              

    	addi        $t6,    $t6,    -1          # startIndex减1
    	bgez        $t6,    bit_shift_loop      # 如果startIndex大于等于0，跳转到bit_shift_loop

# -- 将计算结果转换为16进制 --
convert_to_hex: 				# a0为要输出的数，a1 = 0 时，输出3:0，否则输出31:8
    	bne         $a1,    0,      high        # 如果a1不为0，跳转到high
    	low: # 输出3:0
    	andi        $a0,    $a0,   0xf          # 取$a0的低4位
    	lb          $a0,    hex_table($a0)      # 将对应的16进制字符加载到$a0
    	li          $v0,    11                  # 打印字符
    	j           convert_to_hexEnd           # 跳转到convert_to_hexEnd

high: 						# 输出31:8
    	srl         $a0,    $a0,    8           # 将$a0右移8位
    	li          $t9,    5                   # 设置计数器$t9为5

convert_to_hexLoop:
    	andi        $t7,    $a0,    0xf         # 取$a0的低4位，存入$t7
    	lb          $t8,    hex_table($t7)      # 将对应的16进制字符加载到$t8
    	sb          $t8,    hex_digits($t9)     # 存储到hex_digits数组中
    	sub         $t9,    $t9,    1           # 计数器$t9减1
    	srl         $a0,    $a0,    4           # 将$a0右移4位
    	bgez        $t9,    convert_to_hexLoop  # 如果计数器$t9大于等于0，继续循环

    	la          $a0,    hex_digits          # 加载hex_digits数组地址到$a0

    	li          $v0,    4                   # 打印字符串
convert_to_hexEnd:
    	syscall

    	jr          $ra                      	# 返回跳转处

# --	退出程序    --
exit:
	la		$a0,	msg_exit	# 输出再见语
	li		$v0,	4	
	syscall 
    	li          $v0,    10                  # 退出程序
    	syscall                              

