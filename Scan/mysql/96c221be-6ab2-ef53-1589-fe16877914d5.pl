#!env perl
#Author: autoCreated
my $para_num = "3";
my $template_time = "2015-03-17 11:15:16";
my %para;
@array_pre_flag = ();
@array_appendix_flag = ();

$para{MySQL_user} = $ARGV[1];
$para{MySQL_port} = $ARGV[2];
$para{MySQL_password} = $ARGV[3];


$pre_cmd{1738} = "mysql -u\"$para{MySQL_user}\" -p\"$para{MySQL_password}\" -h127.0.0.1 --port=$para{MySQL_port} -e\"use mysql;select user from user where user = '';\"";
$pre_cmd{6910} = "ps -ef | grep mysqld";
$pre_cmd{7849} = "mysql -u\"$para{MySQL_user}\" -p\"$para{MySQL_password}\" -h127.0.0.1 --port=$para{MySQL_port} -e\"use mysql;select user from user;\">/tmp/user.txt
cat /tmp/user.txt | grep -v root | grep -v user
";
$pre_cmd{4947} = "mysql -u\"$para{MySQL_user}\" -p\"$para{MySQL_password}\" -h127.0.0.1 --port=$para{MySQL_port} -e\"use mysql;select Password from user where Password = '';\"";
$pre_cmd{6577} = "mysql -u\"$para{MySQL_user}\" -p\"$para{MySQL_password}\" -h127.0.0.1 --port=$para{MySQL_port} -e\"show variables like 'log_error'\\G;\"";
$pre_cmd{6945} = "mysql -u\"$para{MySQL_user}\" -p\"$para{MySQL_password}\" -h127.0.0.1 --port=$para{MySQL_port} -e\"show variables like 'log_slave_updates'\\G;\"";
$pre_cmd{6944} = "mysql -u\"$para{MySQL_user}\" -p\"$para{MySQL_password}\" -h127.0.0.1 --port=$para{MySQL_port} -e\"show variables like 'log_bin'\\G;\"";
$pre_cmd{6903} = "mysql -u\"$para{MySQL_user}\" -p\"$para{MySQL_password}\" -h127.0.0.1 --port=$para{MySQL_port} -e\"show variables like 'slow_query_log'\\G;\"";
$pre_cmd{6523} = "mysql -u\"$para{MySQL_user}\" -p\"$para{MySQL_password}\" -h127.0.0.1 --port=$para{MySQL_port} -e\"show variables like 'general_log'\\G;\"";
$pre_cmd{7697} = "mysql -u\"$para{MySQL_user}\" -p\"$para{MySQL_password}\" -h127.0.0.1 --port=$para{MySQL_port} -e\"show variables like 'max_connections'\\G;\"";

push(@array_pre_flag, 1738);
push(@array_pre_flag, 6910);
push(@array_pre_flag, 7849);
push(@array_pre_flag, 4947);
push(@array_pre_flag, 6577);
push(@array_pre_flag, 6945);
push(@array_pre_flag, 6944);
push(@array_pre_flag, 6903);
push(@array_pre_flag, 6523);
push(@array_pre_flag, 7697);


$appendix_cmd{2} = "mysql -u\"$para{MySQL_user}\" -p\"$para{MySQL_password}\" -h127.0.0.1 --port=$para{MySQL_port} -e\"show variables like 'skip_networking'\\G;\"";$appendix_cmd{0} = "mysql -u\"$para{MySQL_user}\" -p\"$para{MySQL_password}\" -h127.0.0.1 --skip-column-names --port=$para{MySQL_port} -e\"use mysql;select User,Host from user ;\" | sed \"s/|//\"";$appendix_cmd{1} = "mysql -u\"$para{MySQL_user}\" -p\"$para{MySQL_password}\" -h127.0.0.1 --skip-column-names --port=$para{MySQL_port} -e\"use mysql;select version();\" | grep -v \"+--\"";
push(@array_appendix_flag, 2);
push(@array_appendix_flag, 0);
push(@array_appendix_flag, 1);

sub get_os_info{
 my %os_info = (
 "hostname"=>"","osname"=>"","osversion"=>"");
 $os_info{"hostname"} = `uname -n`;
 $os_info{"osname"} = `uname -s`;
 $os_info{"osversion"} = `uname -r`;
foreach (%os_info){   chomp;}
return %os_info;}

sub add_item{
 my ($string, $flag, $command, $value)= @_;
 $string .= "\t\t".'<item flag="'.$flag.'">'."\n";
 $string .= "\t\t\t".'<cmd info="'.$date.'">'."\n";
 $string .= "\t\t\t<command><![CDATA[".$command."]]></command>\n";
 $string .= "\t\t\t<value><![CDATA[".$value."]]></value>\n";
 $string .= "\t\t\t</cmd>\n";
 $string .= "\t\t</item>\n";
return $string;}
 sub generate_xml{
 $ARGC = @ARGV;
if($ARGC lt 4){
 print qq{usag:uuid.pl IP  数据库用户名 端口号 数据库密码};
exit;}
my %os_info = get_os_info();
 my $os_name = $os_info{"osname"};
 my $host_name = $os_info{"hostname"};
 my $os_version = $os_info{"osversion"};
 my $date = `date +%y-%m-%d`;
 chomp $date;
 my $ipaddr = $ARGV[0];
 my $xml_string = "";
 $xml_string .='<?xml version="1.0" encoding="UTF-8"?>'."\n";
 $xml_string .= '<result uuid= "'.'96c221be-6ab2-ef53-1589-fe16877914d5'.'" ip="'.$ipaddr.'" template_time= "2015-03-17 11:15:16'.'">'."\n";
 $xml_string .= "\t".'<initcmd>'."\n";
 $xml_string .= "\t\t".'<cmd info="'.$date.'">';
 $xml_string .= '</cmd>'."\n";
 $xml_string .= "\t\t\t".'<command><![CDATA[ ]]></command>'."\n";
 $xml_string .= "\t\t\t".'<value><![CDATA[ ]]></value>'."\n";
 $xml_string .= "\t".'</initcmd>'."\n";
 $xml_string .= "\t".'<security type="auto">'."\n";
 foreach $key (@array_pre_flag){
 $value = $pre_cmd{$key};
 my $tmp_result = `$value`;
 chomp $tmp_result;
 $tmp_result =~ s/>/&gt;/g;
 $xml_string = &add_item( $xml_string, $key, $value, $tmp_result );}
 $xml_string .= "\t</security>\n";
 $xml_string .= "\t".'<security type="display">'."\n";
 foreach $key (@array_appendix_flag){
 $value = $appendix_cmd{$key};
 my $tmp_result = `$value`;
 chomp $tmp_result;
 $tmp_result =~ s/>/&gt;/g;
 $xml_string = &add_item( $xml_string, $key, $value, $tmp_result );}
 $xml_string .= "\t"."</security>"."\n";
 $xml_string .= "</result>"."\n";
 $xmlfile = $ipaddr."_"."96c221be-6ab2-ef53-1589-fe16877914d5"."_chk.xml";
 print $xmlfile."\n";
 open XML,">/tmp/".$xmlfile or die "Cannot create ip.xml:$!";
 print XML $xml_string;
 print "end write xml\n";
 print "DONE ALL\n";}
 generate_xml();
