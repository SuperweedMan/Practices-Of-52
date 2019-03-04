;多按点矩阵键盘 扫描法
		ORG 0000H
		LJMP MAIN
MAIN:	MOV SP,#60H
LOOP:	MOV P0,#0FH		;初始化
		MOV 30H,#0		;检查到几个有效按键
		LCALL DELAY
		MOV A,P0
		CJNE A,#0FH,SE1
		SJMP LOOP
SE1:	LCALL DELAY		;消抖
		MOV A,P0
		CJNE A,#0FH,SE2
		SJMP LOOP
SE2:	MOV R2,#4 		;循环扫描四列
		MOV R6,#0EFH
		MOV P0,R6   	;扫描一列
SE5:	MOV R3,#4		;循环扫描四行
		SETB C
		MOV A,P0
SE4:	RRC A
		JNC SE3			;扫描到行有效
		DJNZ R3,SE4		;继续扫描下一行
		LJMP  SE6		;本列无
SE3:	INC 30H			;有效按键加1
		MOV A,#4
		SUBB A,R3		;前面有几行
		MOV B,#4
		MUL AB			;前面有几个按键
		MOV 31H,A		;暂存
		MOV A,#5
		SUBB A,R2
		ADD A,31H		;求键值
		PUSH ACC		;键值入栈
SE6:	MOV A,R6		;开始换下一列
		SETB C
		RLC A
		MOV R6,A
		MOV P0,R6
		DJNZ R2,SE5
		MOV P0,#0FH
TECH:	MOV A,P0		;松手检测
		CJNE A,#0FH,TECH
		MOV R5,30H		;开始出栈所有按键
DIS:	POP ACC
		MOV P1,A
		DJNZ R5,DIS
		LCALL DELAY
		LJMP LOOP

DELAY:	PUSH 30H
		PUSH 31H
		MOV 30H,#20
DELAY1:	MOV 31H,#249
		DJNZ 31H,$
		DJNZ 30H,DELAY1
		POP 31H
		POP 30H
		RET
		
		END