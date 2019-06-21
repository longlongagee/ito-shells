#!env perl
#Author: autoCreated
my $para_num = "3";
my $template_time = "2015-09-18 03:17:54";
my %para;
@array_pre_flag = ();
@array_appendix_flag = ();

$para{Tomcat_su_user} = $ARGV[1];
$para{Tomcat_su_password} = $ARGV[2];
$para{Tomcat_config_dir_path_linux} = $ARGV[3];


$pre_cmd{1144} = "cat \"$para{Tomcat_config_dir_path_linux}/tomcat-users.xml\"";
$pre_cmd{3417} = "awk -f  /tmp/awkxmlfilter tomcat-users.xml | grep password > /tmp/tmp129
awk -F\"password=\" '{split(\$2,s,\"\\\"\");if(length(s[2])<=7){print \$1,\"unvalid\"}}' /tmp/tmp129
";
$pre_cmd{3166} = "cat \"$para{Tomcat_config_dir_path_linux}/tomcat-users.xml\"";
$pre_cmd{4613} = "cd $para{Tomcat_config_dir_path_linux}
awk -f  /tmp/awkxmlfilter tomcat-users.xml | grep -E -e 'user.+username\\s*=\\s*\"tomcat\".+manager' || echo not config";
$pre_cmd{5717} = "cat \"server.xml\"";
$pre_cmd{6902} = "cat \"server.xml\"";
$pre_cmd{7668} = "cat \"server.xml\"";
$pre_cmd{9697} = "cat \"web.xml\"";
$pre_cmd{9855} = "awk -f /tmp/awkxmlfilter web.xml";

push(@array_pre_flag, 1144);
push(@array_pre_flag, 3417);
push(@array_pre_flag, 3166);
push(@array_pre_flag, 4613);
push(@array_pre_flag, 5717);
push(@array_pre_flag, 6902);
push(@array_pre_flag, 7668);
push(@array_pre_flag, 9697);
push(@array_pre_flag, 9855);


$appendix_cmd{0} = "awk -f /tmp/awkxmlfilter tomcat-users.xml  | grep username";$appendix_cmd{2} = "cp $para{Tomcat_config_dir_path_linux}/../bin/version.sh $para{Tomcat_config_dir_path_linux}/../bin/tmpversion.sh
chmod +x $para{Tomcat_config_dir_path_linux}/../bin/tmpversion.sh
$para{Tomcat_config_dir_path_linux}/../bin/tmpversion.sh
rm -f $para{Tomcat_config_dir_path_linux}/../bin/tmpversion.sh";$appendix_cmd{1} = "awk -f /tmp/awkxmlfilter server.xml > temconn211
awk -f /tmp/c213 temconn211
rm -f /tmp/awkxmlfilter /tmp/c213 temconn211";
push(@array_appendix_flag, 0);
push(@array_appendix_flag, 2);
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
 print qq{usag:uuid.pl IP  SU用户名 SU用户密码 配置文件所在目录(eg:/usr/local/apache-tomcat-6.0.37/conf)};
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
 $xml_string .= '<result uuid= "'.'96c221be-6ab2-ef53-1589-fe16877914a8'.'" ip="'.$ipaddr.'" template_time= "2015-09-18 03:17:54'.'">'."\n";
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
 $xmlfile = $ipaddr."_"."96c221be-6ab2-ef53-1589-fe16877914a8"."_chk.xml";
 print $xmlfile."\n";
 open XML,">/tmp/".$xmlfile or die "Cannot create ip.xml:$!";
 print XML $xml_string;
 print "end write xml\n";
 print "DONE ALL\n";}
 generate_xml();
