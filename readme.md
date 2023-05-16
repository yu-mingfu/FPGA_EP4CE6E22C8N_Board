# FPGA 的使用说明

![image-20230509080106345](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509080106345.png) 

------

## 一、硬件设计说明

FPGA最小系统是可以使FPGA正常工作的最简单的系统。它的外围电路尽量最少，只包括FPGA必要的控制电路。一般所说的FPGA的最小系统主要包括FPGA芯片、下载电路、外部时钟、复位电路和电源。

FPGA的引脚主要包括：**用户I/O、配置管脚、电源、时钟以及特殊应用管脚等**，以Altera 的 EP4CE6E22C8N为例，介绍FPGA的各种功能管脚。

### 1.1 FPGA引脚介绍

**用户I/O：**

I/Onum(LVDSnumn)：可用作输入或输出，或者双向口，同时可作为LVDS(低压350mV差分信号)差分对的负端。其中num表示管脚序号；



**配置管脚：**

MSEL[1..0]：用于选择配置模式。FPGA有多种配置模式，比如主动、被动、快速、正常、串行、并行等，可以此管脚进行选择；

DATA0：FPGA串行数据输入，连接至配置器件的串行数据输出管脚；

DCLK：FPGA串行时钟输出，为配置器件提供串行时钟；

nCSO(I/O)：FPGA片选信号输出，连接至配置器件的nCS管脚；

ASDO(I/O)：FPGA串行数据输出，连接至配置器件的ASDI管脚；

nCEO：下载链器件使能输出。在一条下载链(Chain)中，当第一个器件配置完成后，此信号将使能下一个器件开始进行配置。下载链的最后一个器件的nCEO应悬空；

nCE：下载链器件使能输入，连接至上一个器件的nCEO。下载链第一个器件的nCE接地；

nCONFIG：用户模式配置起始信号；

nSTATUS：配置状态信号；

CONF_DONE：配置结束信号；



**电源管脚：**

VCCINT：内核电压。通常与FPGA芯片所采用的工艺有关，例如130nm工艺为1.5V，90nm工艺为1.2V；

VCCIO：端口电压。一般为3.3V，还可以支持选择多种电压，如5V、1.8V、1.5V等；

VREF：参考电压；

GND：信号地；



**时钟管脚：**

VCC_PLL：锁相环管脚电压，直接连VCCIO；

VCCA_PLL：锁相环模拟电压，一般通过滤波器接到VCCINT上；

GNDA_PLL：锁相环模拟地；

GNDD_PLL：锁相环数字地；

CLKnum(LVDSCLKnump)：锁相环时钟输入。支持LVDS时钟输入，p接正端，num表示PLL序号；

CLKnum(LVDSCLKnumn)：锁相环时钟输入。支持LVDS时钟输入，n接负端，num表示PLL序号；

PLLnum_OUTp(I/O)：锁相环时钟输出。支持LVDS时钟输入，p接正端，num表示PLL序号；

PLLnum_OUTn(I/O)：锁相环时钟输出。支持LVDS时钟输入，n接负端，num表示PLL序号；

另外，FPGA的管脚中，有一些是全局时钟，这些管脚在FPGA中已经做好了时钟树。使用这些管脚作为关键时钟或信号的布线可以获得最佳性能。



**特殊管脚：**

VCCPD：用于选择驱动电压；

VCCSEL：用于控制配置管脚和锁相环相关的输入缓冲电压；

PORSEL：上电复位选项；

NIOPULLUP：用于控制配置时所使用的用户I/O的内部上拉电阻是否工作；

TEMPDIODEn/p：用于关联温度敏感二极管；



### 1.2 FPGA电路设计

#### 1.2.1 电源电路

![image-20230509085817445](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509085817445.png) 

![image-20230509085829831](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509085829831.png) 

- VCCINT: 内核电源，负责给内部逻辑阵列电源引脚供电。电源支持1.0V/1.2V 但要求电压偏差在 ± 30 mV / ± 50 mV以内;
- VCCD_PLL: 锁相环的数字电源，要求同上，VCCINT 和 VCCD_PLL 可以使用同一个电源供电，但VCCINT 和 VCCD_PLL 间必须有**一个合适的滤波器**（磁珠），且VCCD_PLL 对电源纹波要求特别高，最大纹波必须控制在 ±3% 以内，超过这个范围将导致锁相环工作异常；
- VCCIO:  VCCIO是给FPGA各个BANK（每个BANK 包含若干个引脚，这些引脚电平与该BANK 的 VCCIO相同，不同BANK 可以有不同电压的 VCCIO ，这样就实现了一颗芯片支持多种电平，无需外部电平转换电路）的IO供电的，Cyclone IV E的VCCIO支持1.2V、1.5V、1.8V、2.5V、3.0V、3.3V几种电压；
- VCCA: VCCA是给PLL的模拟电路供电的，使用2.5V供电，电源纹波一样要求控制在 ±3%以内；



根据数据手册中的要求，使用USB 提供5V电源，通过MT3420B 开关电源将其转换为3.3V，通过两个LDO分别转换成1.2V和2.5V电源。

![image-20230509085924896](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509085924896.png) 

![image-20230509090138088](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509090138088.png) 

#### 1.2.2 时钟电路

Cyclone IV E 器件提供了多达 15 个专用时钟管脚 (CLK[15..1])，以用于驱动高达 20 个 GCLK（全局时钟）。Cyclone IV E 器件的左侧支持三个专用时钟管脚，在顶端、底部及右侧支持 四个专用时钟管脚 (EP4CE6 与 EP4CE10 器件除外 )。EP4CE6 和 EP4CE10 器件仅在器件 左侧支持三个专用时钟管脚，在器件右侧支持四个专用时钟引脚。

**全局时钟：**

全局时钟网络是FPGA内部一组特殊的信号通路，在FPGA内部对称分布。时钟信号到达FPGA内部各个触发器的时间相近，以保证信号的同步性。在全局时钟网络中可以接入时钟信号（晶振），也可以接入同步/异步清零信号，使能信号等高扇出（模块直接调用的下级模块的个数，如果这个数值过大的话，在FPGA直接表现为net delay较大，不利于时序收敛）的信号。

**全局时钟网络来源如下图所示：**

![image-20230509091755606](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509091755606.png) 

- FPGA的内部逻辑；
- DPCLK引脚；
- CLK引脚；
- 经过CLK引脚输入的PLL输出；

![image-20230509092131271](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509092131271.png) ![image-20230509092153893](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509092153893.png) 

EP4CE6E22C8N 只有7个时钟引脚，使用了其中两个引脚，一个作为晶振的输入，一个作为复位信号输入。需要注意的是，FPGA内部没有像单片机一样的震荡电路，因此不能使用**无源晶体振荡器**，只能使用**有源晶振**。

#### 1.2.3 下载电路

**FPGA 端**

FPGA 有多种程序下载模式，JTAG、PS、AS等，使用JTAG下载 .sof程序，会将程序直接下载至FPGA内部，其内部没有非易失性存储器，所以掉电程序会丢失；下载 .jic程序，会将程序保存至FPGA芯片外部的一个程序配置Flash芯片中，这样就实现了程序掉电不丢失。

![image-20230509093804156](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509093804156.png) ![image-20230509093819080](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509093819080.png) 

上图为程序配置Flash电路（左）和 FPGA下载电路（JTAG）

**下载器端**

FPGA下载器有很多方案，网上比较廉价的是使用一款具有USB功能的单片机（PIC18F14K50-I/SS）和电平转换电路（非必要）构成。板子没有预留PIC单片机的下载电路，因此需要提前将USB-Blaster的程序下载至PIC单片机中，然后将其焊接至PCB板上使用。

![image-20230509094516762](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509094516762.png) 

![image-20230509094558472](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509094558472.png) ![image-20230509094609232](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509094609232.png) ![image-20230509094618991](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509094618991.png) 

#### 1.2.4 其余外设电路

板子上包括了USB转串口电路、HDMI电路（仅作输出）、按键电路、LED电路、TFT-LCD电路（SPI）、EEPROM和SHT20电路(IIC)和SDRAM电路。

------

## 二、软件环境搭建

### 2.1 Quartus II 的安装

#### 2.1.1 软件本体安装

- **以管理员身份运行箭头所指软件安装包，并按照默认按照设置完成安装；**

![image-20230508184113720](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230508184113720.png) 

![image-20230508184302661](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230508184302661.png) 

![image-20230508190517755](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230508190517755.png) 

#### 2.1.2 器件库的安装

- **安装完Quartus II 后，打开器件库安装程序；**

![image-20230508190740280](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230508190740280.png) 

![image-20230508190901398](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230508190901398.png) 

#### 2.1.3 软件破解

- **将Quartus 破解器复制到Quartus 软件安装目录下的bin64 文件夹下，运行破解器，点击应用，并将生成的License文件保存至bin64文件夹下；**

![image-20230508191743578](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230508191743578.png) 



- **打开软件，找到软件的NIC 的 ID ，复制其中一个；**

![image-20230508192049761](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230508192049761.png) 



- **将License.bat文件中的XXXXXXXX全部替换成刚才复制的ID，并重新打开软件，点击Tools 找到License setup  设置 License file 的路径;**

![image-20230508192357213](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230508192357213.png) 



#### 2.1.4 USB Blaster 驱动安装

FPGA程序的下载，上板调试和验证都离不开USB Blaster 下载器，初次使用下载器需要安装驱动；在Quartus II 软件的安装过程中已经将USB Blaster 驱动写入安装文件中，我们只需要更新一下驱动程序即可。在设备管理器中右键USB-Blaster 更新驱动程序，并在软件安装目录下的driver\usb-blaster 目录下搜索驱动程序。

![image-20230508193458589](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230508193458589.png) 

### 2.2 ModelSim SE 的安装

ModelSim 是业界最优秀的HDL语言仿真软件之一，编译仿真速度快；编译的代码与平台无关，便于保护IP核；个性化的图形界面和用户接口，为用户加快调错提供强有力的手段，是FPGA/ASIC设计的首选仿真软件。

ModelSim 有SE、PE、LE和OEM几种不同的版本，其中SE是最高级的版本，而集成在Altera、Xilinx以及Lattice等FPGA厂商设计工具中均是OEM版本；与之相比，SE版本仿真速度更快，而且可以兼容不同的FPGA开发软件，因此需要单独安装ModelSim SE。

#### 2.2.1 软件本体安装

- **以管理员身份运行安装程序；**

![image-20230508194714300](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230508194714300.png) 

**安装过程中弹出的对话框都选择“是”，是否重启选择“否”。**但在下面的对话框中一定要选择否，否则会导致电脑蓝屏死机。如果出现蓝屏死机现象，需要删除C:\Windows\System32\drivers\hardlock.sys 文件。

![image-20230509110224487](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509110224487.png) 

#### 2.2.2 软件破解

- **将下图左侧前三个文件复制到ModelSim 安装目录下的win64 文件夹中；**

![image-20230509081156753](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509081156753.png) 



- **通过CMD 运行patch64_dll.bat程序，直接运行可能会导致失败；**

![image-20230509081317871](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509081317871.png) 



- **保存其导出的LICENSE.TXT 文件，并将其添加到下图所示的环境变量中；**

![image-20230509081525665](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509081525665.png) 

### 2.3 软件关联

- **按照下图所示完成Quartus 与 ModelSim 的关联；**

![image-20230509082243371](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509082243371.png) 



- **按照下图所示完成Quartus 与 Notepad++ 的关联；**

![image-20230509082415058](F:\VSCode\Markdown\【笔记】FPGA\images\image-20230509082415058.png) 

------

## 三、引脚分配表

| 外设管脚                      | FPGA引脚 |
| ----------------------------- | -------- |
| 复位按键Reset（按下为低电平） | PIN_25   |
| 50MHz时钟                     | PIN_23   |
|                               |          |
| 按键KEY1（按下为低电平）      | PIN_11   |
| 按键KEY2                      | PIN_10   |
| 按键KEY3                      | PIN_7    |
|                               |          |
| LED1/CP2102_TX（低电平点亮）  | PIN_3    |
| LED2/CP2102_RX                | PIN_2    |
| LED3                          | PIN_1    |
| LED4                          | PIN_144  |
|                               |          |
| HDMI_CLK_N                    | PIN_84   |
| HDMI_CLK_P                    | PIN_85   |
| HDMI_DATA0_N                  | PIN_86   |
| HDMI_DATA0_P                  | PIN_87   |
| HDMI_DATA1_N                  | PIN_98   |
| HDMI_DATA1_P                  | PIN_99   |
| HDMI_DATA2_N                  | PIN_101  |
| HDMI_DATA2_P                  | PIN_103  |
| HDMI_SCL                      | PIN_105  |
| HDMI_SDA                      | PIN_104  |
| HDMI_HPD                      | PIN_106  |
|                               |          |
| I2C_SCL（EEPROM，SHT20）      | PIN_110  |
| I2C_SDA                       | PIN_113  |
|                               |          |
| SPI_LCD_SDA（0.96TFT_LCD）    | PIN_120  |
| SPI_LCD_SCL                   | PIN_115  |
| SPI_LCD_DC                    | PIN_112  |
| SPI_LCD_RES                   | PIN_114  |
| SPI_LCD_BL                    | PIN_119  |
|                               |          |
| SDRAM                         |          |
| S_DQ0                         | PIN_28   |
| S_DQ1                         | PIN_30   |
| S_DQ2                         | PIN_31   |
| S_DQ3                         | PIN_32   |
| S_DQ4                         | PIN_33   |
| S_DQ5                         | PIN_34   |
| S_DQ6                         | PIN_38   |
| S_DQ7                         | PIN_39   |
| S_DQ8                         | PIN_54   |
| S_DQ9                         | PIN_53   |
| S_DQ10                        | PIN_52   |
| S_DQ11                        | PIN_51   |
| S_DQ12                        | PIN_50   |
| S_DQ13                        | PIN_49   |
| S_DQ14                        | PIN_46   |
| S_DQ15                        | PIN_44   |
| S_A0                          | PIN_76   |
| S_A1                          | PIN_77   |
| S_A2                          | PIN_80   |
| S_A3                          | PIN_83   |
| S_A4                          | PIN_68   |
| S_A5                          | PIN_67   |
| S_A6                          | PIN_66   |
| S_A7                          | PIN_65   |
| S_A8                          | PIN_64   |
| S_A9                          | PIN_60   |
| S_A10                         | PIN_75   |
| S_A11                         | PIN_59   |
| SD_BS0                        | PIN_73   |
| SD_BS1                        | PIN_74   |
| SD_LDQM                       | PIN_42   |
| SD_UDQM                       | PIN_55   |
| SD_CKE                        | PIN_58   |
| SD_CLK                        | PIN_43   |
| SD_CS                         | PIN_72   |
| SD_RAS                        | PIN_71   |
| SD_CAS                        | PIN_70   |
| SD_WE                         | PIN_69   |

