   M S B A M L   `   `   `  ����A  =Client, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null5clr-namespace:Client.ConvertersClient.Converters  5   	       Client.MainWindow   5   	   \ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   X TXceed.Wpf.Toolkit, Version=2.9.0.0, Culture=neutral, PublicKeyToken=3e4669d2f30244f44xctk)http://schemas.xceed.com/wpf/xaml/toolkit  5   	   0
convertersclr-namespace:Client.Converters  5   	     � Title$  Client��5	   	   $	��450��6   $	��800��6%    � 	Resources 5
      3   -Client.Converters.BoolToClientStatusConverter   BoolToClientStatusConverter=   7Client.Converters.BoolToClientConnectionStatusConverter ) %BoolToClientConnectionStatusConverter.   (Client.Converters.StatusToColorConverter  ColorConverter �� 
TargetType �� Property �� Value%  Xceed.Wpf.Toolkit.IntegerUpDown��%�  &	        &	      &	 &     '�� 9     '  �     '�� !    '�� �    '�� 9      5   
   61     5   
   6;     5   
   6,   �� 5   
   " ��6   .�5      ��  � ��$ 3q�6'   63   �� 5       � ��$ 3q�6(   64   5      �� 5   
   "  6   .�5      ��  � ��$ 3q�6'   63   �� 5       � ��$ 3q�6(   64   5      �� 5   
   " ��6   .�5      ��  � ��$ Center=�62   6C   �� 5       � ��$	 120��6&   64   �� 5       � ��$ 3q�6'   63   5      �� 5   
   " ��6   .�5      ��  � ��$ 70��6&   63   �� 5       � ��$ 3q�6'   63   5      �� 5   
   " ��6   .�5       ��  � ��$ 3q�6'   63   5!      5"      .��5#      ]� $��0 10 0 0q�6   .+�5$   
   �� -   5        $��	StatusBar��5$      $��Bottom=�6%   .@�5%      �� .��5&      �� ��6   ��  �� Path$ IsActive� �� 	Converter# [  ��5'      �� $ IsActive�# [ 5(      5)      � 5*   
   -   5        $��gridControl��5*      $	��Top=�6"    � ColumnDefinitions 5+      �� 5,      $
��Auto �6#   �� 5-      �� 5.      $
��Auto �6#   �� 5/      $
��Auto �6#    � RowDefinitions 51      �� 52      �� 53      �� 54      �� 55      .+�57      �� $��0��6   $��0��6(   $��Socket Address��65   �� 58      $��1��6   $��0��6&   ��63   �� $ 	IpAddress�	 �� UpdateSourceTrigger$	 PropertyChanged=�{�59      �� $ IsNotActive�  5:      $��2��6!   $��0��61   $��70��5;   !   ,  &Xceed.Wpf.Toolkit.Primitives.InputBase
   Text
 5:   >   �� $
 Port�$	 PropertyChanged=�{�5;   ,   �� $ IsNotActive��� 5=      $��0��6   $��1��6(   $��Username��65   �� 5>      -   5        $��Username��5>   3   $��1��6   $��1��6&   ��6C   �� $ Username�$	 PropertyChanged=��� 5@      -   5        $��ConnectButton��5@      $��3��6*   $��0��6:   $��2��6G   ��5A      �� $ IsNotActive�# [ 5B      �� 5D      $��0��6   $��2��6(   $��Target username��65   �� 5E      -   5        $��TargetUsername��5E      $��1��6,   $��2��6<   �� 5G      $��0��6   $��3��6(   $��Message��65   �� 5H      -   5        $��MessageToSend��5H      $��1��6+   $��3��6;   �� 5J      -   5        $��SendMessageButton��5J      $��3��6.   $��2��6>   $��2��6K   $
��Send��6\   5K      5L      �� 5M   
   ��6   �� $ Messages�5N      5O      