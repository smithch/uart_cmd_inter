vlib work 

vlog -work work tb_uart_cmd_inter.sv uart_cmd_inter.sv uart_tx.v uart_rx.v
vsim work.tb_uart_cmd_inter

add wave *
add wave dut.dv
add wave dut.rxByte
add wave dut.rx.o_Rx_Byte
add wave tx.r_SM_Main
add wave dut.rx.r_SM_Main
add wave tx.r_Clock_Count
add wave tx.o_Tx_Serial
add wave dut.cmd_buff
run -All
