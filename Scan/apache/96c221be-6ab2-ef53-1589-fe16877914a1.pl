#!env perl
#Author: autoCreated
my $para_num = "3";
my $template_time = "2015-05-13 11:52:32";
my %para;
@array_pre_flag = ();
@array_appendix_flag = ();

$para{Apache_linux_user} = $ARGV[1];
$para{Apache_linux_pwd} = $ARGV[2];
$para{Apache_linux_install_dir_path} = $ARGV[3];


$pre_cmd{5} = "grep -e 'LimitRequestBody' /tmp/infile | grep -v -e '# *LimitRequestBody' | awk '{print \$2}'";
$pre_cmd{4} = "grep -e 'LimitRequestBody' /tmp/infile | grep -v -e '# *LimitRequestBody' | awk '{print \$2}'";
$pre_cmd{15} = "cat \"/tmp/infile\"";
$pre_cmd{16} = "grep -i -e 'KeepAlive' /tmp/infile";
$pre_cmd{34} = "ls $para{Apache_linux_install_dir_path}/htdocs | wc -l";
$pre_cmd{33} = "ls  $para{Apache_linux_install_dir_path}/cgi-bin | wc -l";
$pre_cmd{3} = "cat \"/tmp/infile\"";
$pre_cmd{32} = "ls  $para{Apache_linux_install_dir_path}/manual | wc -l";
$pre_cmd{8} = "cat /tmp/infile | grep -i \"ErrorDocument\"";
$pre_cmd{7} = "cat /tmp/infile | grep -i \"ErrorDocument\"";
$pre_cmd{10} = "cat /tmp/infile | grep -i \"ErrorDocument\"";
$pre_cmd{9} = "cat /tmp/infile | grep -i \"ErrorDocument\"";
$pre_cmd{13} = "grep -i  -e  'ServerTokens'  /tmp/infile";
$pre_cmd{14} = "grep -i 'ServerSignature'  /tmp/infile";
$pre_cmd{6} = "cat /tmp/infile | grep -i \"ErrorDocument\"";
$pre_cmd{12} = "grep -i -E -e 'options.+indexes' /tmp/infile";
$pre_cmd{17} = "grep -i -e 'KeepAliveTimeout' /tmp/infile";
$pre_cmd{18} = "grep -i -e 'AcceptFilter' /tmp/infile";
$pre_cmd{19} = "grep -i -E -e 'AcceptFilter' /tmp/infile";
$pre_cmd{35} = "cat /tmp/infile | grep -i LogLevel";
$pre_cmd{36} = "cat /tmp/infile | grep -i ErrorLog";
$pre_cmd{37} = "cat /tmp/infile | grep -i CustomLog";
$pre_cmd{38} = "cat /tmp/infile | grep -v \"#\" |  grep -i  LogFormat";
$pre_cmd{1} = "grep -e  '^\\s*User' /tmp/infile | awk '{print \$2}'";
$pre_cmd{2} = "grep -i -e  '^\\s*group' /tmp/infile | awk '{print \$2}'";
$pre_cmd{11} = "cat /tmp/infile | grep -i \"ErrorDocument\"";

push(@array_pre_flag, 5);
push(@array_pre_flag, 4);
push(@array_pre_flag, 15);
push(@array_pre_flag, 16);
push(@array_pre_flag, 34);
push(@array_pre_flag, 33);
push(@array_pre_flag, 3);
push(@array_pre_flag, 32);
push(@array_pre_flag, 8);
push(@array_pre_flag, 7);
push(@array_pre_flag, 10);
push(@array_pre_flag, 9);
push(@array_pre_flag, 13);
push(@array_pre_flag, 14);
push(@array_pre_flag, 6);
push(@array_pre_flag, 12);
push(@array_pre_flag, 17);
push(@array_pre_flag, 18);
push(@array_pre_flag, 19);
push(@array_pre_flag, 35);
push(@array_pre_flag, 36);
push(@array_pre_flag, 37);
push(@array_pre_flag, 38);
push(@array_pre_flag, 1);
push(@array_pre_flag, 2);
push(@array_pre_flag, 11);


$appendix_cmd{3} = "cat /tmp/infile | grep -v \"#\" | grep -i  -e customlog";$appendix_cmd{4} = "cat /tmp/infile | grep -v \"#\" | grep -i  -e logformat
rm -f /tmp/infile";$appendix_cmd{1} = "cat /tmp/infile | grep -i -e ^User -e ^Group | sed '/^\\s*\$/d'";$appendix_cmd{5} = "apache2 -v; apachectl -v;$para{Apache_linux_install_dir_path}/bin/httpd -v";$appendix_cmd{2} = "cat /tmp/infile | grep -v \"#\" | grep -i  -e errorlog";$appendix_cmd{0} = "if [ `uname -s` = \"Linux\" ]; then uname -n&&uname -s&&uname -r | sed '/^\\s*\$/d';elif [ `uname -s` = \"AIX\" ];then uname -n&&uname -s && oslevel;fi";
push(@array_appendix_flag, 3);
push(@array_appendix_flag, 4);
push(@array_appendix_flag, 1);
push(@array_appendix_flag, 5);
push(@array_appendix_flag, 2);
push(@array_appendix_flag, 0);

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
 print qq{usag:uuid.pl IP  SU用户名 SU密码 Apache根目录};
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
 $xml_string .= '<result uuid= "'.'96c221be-6ab2-ef53-1589-fe16877914a1'.'" ip="'.$ipaddr.'" template_time= "2015-05-13 11:52:32'.'">'."\n";
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
 $xmlfile = $ipaddr."_"."96c221be-6ab2-ef53-1589-fe16877914a1"."_chk.xml";
 print $xmlfile."\n";
 open XML,">/tmp/".$xmlfile or die "Cannot create ip.xml:$!";
 print XML $xml_string;
 print "end write xml\n";
 print "DONE ALL\n";}
 generate_xml();
