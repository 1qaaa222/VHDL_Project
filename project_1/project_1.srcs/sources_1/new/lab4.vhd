library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity lab4 is
Port(
    ledsmain: out std_logic_vector(3 downto 0);     --светодиоды
    ledsboard: out std_logic_vector(3 downto 0);    --светодиоды
    pushbuttons:in std_logic_vector(4 downto 0);    --кнопки
    dipswitch:in std_logic_vector(3 downto 0);      --переключатели
    sysclk_p:in std_logic;                          --принимают дифф тактовый сигнал???
    sysclk_n:in std_logic
);
end lab4;


architecture Behavioral of lab4 is

component counter is
Port(
    NOT_LOAD : in std_logic;
    NOT_UD : in std_logic;
    NOT_ENT : in std_logic;
    NOT_ENP : in std_logic;
    CLK : in std_logic;
    A : in std_logic;
    B : in std_logic;
    C : in std_logic;
    D : in std_logic;
    NOT_RCO : out std_logic;
    Qa : out std_logic;
    Qb : out std_logic;
    Qc : out std_logic;
    Qd : out std_logic
);
end component;   

component ibufds            --преобразует дифф сигналы(sysclk_p, sysclk_n в единый тактовый сигнал CLK)
port (
    I, IB : in std_logic;   --
    O     : out std_logic); --
end component;
    
component divider_CLK is    --делитель частоты
port (
    CLK_IN  : in STD_LOGIC;
    CLK_OUT : out STD_LOGIC);
end component;

--создаем сигналы

--управл€ющие сигналы
signal LOAD : std_logic;
signal ENP : std_logic;
signal ENT : std_logic;
signal UD : std_logic;
signal NOT_LOAD : std_logic:='0';           --включена загрузка(при 0, работа счетчика при 1)
signal NOT_ENP : std_logic:='0';            --счетчик включен (при 0)
signal NOT_ENT : std_logic:='0';            --счетчик включен (при 0)
signal NOT_UD : std_logic:='1';             --счет вверх (при 1, вниз при 0)

--тактовые
signal CLK_NO_DIV  : std_logic;             --тактовый перед делителем частоты
signal CLK_DIV      : std_logic;            --тактовый после делител€ частоты


--выходы
signal Qa:std_logic:='0';
signal Qb:std_logic:='0';
signal Qc:std_logic:='0';
signal Qd:std_logic:='0';
signal NOT_RCO:std_logic:='0';

begin



couner_uut: counter 
port map(
    NOT_LOAD =>NOT_LOAD,
    NOT_UD =>NOT_UD,
    NOT_ENT =>NOT_ENT,
    NOT_ENP =>NOT_ENP,
    CLK =>CLK_DIV,                  --на вход счетчика подаем тактовый сигнал после делител€ частоты
    A =>dipswitch(0),               -- значени€ входов берем из значени€ перключателей на схеме
    B =>dipswitch(1),
    C =>dipswitch(2),
    D =>dipswitch(3),
    NOT_RCO=>NOT_RCO ,
    Qa =>Qa,
    Qb =>Qb,
    Qc =>Qc,
    Qd =>Qd
);

buffds: ibufds 
port map (                   --преобразует дифф сигналы(sysclk_p, sysclk_n в единый тактовый сигнал CLK_NO_DIV)
    I  => sysclk_p, 
    IB => sysclk_n, 
    O  => CLK_NO_DIV
);
    
divideri: Divider_CLK
port map (
    CLK_IN  => CLK_NO_DIV, 
    CLK_OUT => CLK_DIV
);

NOT_LOAD<= pushbuttons(0);     --значени€ управл€ющих сигналов берем с кнопок
NOT_ENP<=pushbuttons(1);
NOT_ENT<=pushbuttons(2);
NOT_UD<=pushbuttons(3);


ledsmain(0) <= Qa;            --результаты работы устройства будет отбображатьс€ налампочках
ledsmain(1) <= Qb;
ledsmain(2) <= Qc;
ledsmain(3) <= Qd;

ledsboard(0)<= NOT_RCO;       

end Behavioral;
