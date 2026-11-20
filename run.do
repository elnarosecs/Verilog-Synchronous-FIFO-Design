vlib work
vlog tb.v
vsim -novopt -suppress 12110 top 
add wave -position insertpoint sim:/top/*
run -all
