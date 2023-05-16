/*******************************************************************
**���ǵ�FPGA������
**��վ��www.OurFPGA.com
**�Ա���OurFPGA.taobao.com
**����: OurFPGA@gmail.com
**��ӭ��ҵ�½��վ������FPGA�����Ӽ������ۣ����������Ƶ�̳̼�����
*****************�ļ���Ϣ********************************************
**�������ڣ�   2011.06.07
**�汾�ţ�     version 1.0
**����������   led��ˮ��ʵ��
********************************************************************/
module led_water(key,led);//
input[3:0]key;//
output[3:0]led;
reg[3:0]led_r;
reg[3:0]buffer;
assign led=led_r;

always@(key)
begin
	buffer=key;
	case(buffer)
		8'b1110:led_r=8'b1110;//������µ���key1,��ô����LED1
		8'b1101:led_r=8'b1100;//������µ���key2,��ô����LED1-LED2
		8'b1011:led_r=8'b1000;//key3
		8'b0111:led_r=8'b0000;//key4
	    default:led_r=8'b1111;
	endcase
end
endmodule
	
