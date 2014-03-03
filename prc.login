:'##############################################################:'# 10-3-13 ejl handle login request before reprioritizing allowed:
:'# ripped from issues/post::
:'# incoming parameter list looks like  (too many to fit in pm-pz):'  -r "+pid=12345+rec=22345+pri=4+clk=123+pwd=abc+hot=Y":
::declare extern process_id:
::declare extern recnum;:
::declare extern newpri:
::declare extern userlogin;:
::declare errmsg:
::declare global loginClk(4,.0), loginPass(3,*):
::declare extern hotval:
::gosub getparm        'split parameter list:
::' system "echo \""{@pm<process_id<recnum<newpri<loginClk<loginPass<hotval{"\" | mutt -s login_vars ericl@borisch.com":
DoLogin:'##############################################################:'# login:
::export ascii htm = ("/appl/fpmerge/schedreprior_"{process_id{".pout") R=\n F=,:
::lookup plk = person  K=(loginClk) i=A -nx:
:not plk:errmsg="login failure"; goto loginEr:
:plk(12) ne loginPass:errmsg = "login failure"; goto loginEr:
::userlogin=plk(32):
:'user exists with correct pwd. now make sure they have permission:'to use reprioritize function:
:'12-12-13 changed from process reprior to screen (schedule type):' to make control separate for each schedule list:
::declare type(3,allup):
::lookup schd = scheduling  r=(recnum)  -n:
::type=schd(10):
:@id eq "ericl":goto doit:
::lookup scx = scx_filename  k=(plk(32)&"scheduling    "&type) i=A -nx:
:not scx:errmsg="You do not have permission for this feature on this schedule."; goto loginEr:
doit:'### LOGIN AUTHENICATION SUCCESSFUL...::
::htm(1)="success"; htm(2)="":
::write htm; close htm; sync:
::call "setPriority":
::end:
loginEr:'### HANDLE FAILED AUTHENICATION::
::htm(1)=errmsg:
::htm(2)="":
::write htm; close htm; sync:
::end:
getparm:'split parameter list:'  -r "+pid=12345+rec=22345+pri=4+clk=123+pwd=abc+hot=Y":
::declare pidloc(3,.0),recloc(3,.0),priloc(3,.0),clkloc(3,.0),pwdloc(3,.0),hotloc(3,.0):
::'get starting position of label, make sure they exist:
::pidloc=instr(@pm,"+pid="):
::recloc=instr(@pm,"+rec="):
::priloc=instr(@pm,"+pri="):
::clkloc=instr(@pm,"+clk="):
::pwdloc=instr(@pm,"+pwd="):
::hotloc=instr(@pm,"+hot="):
:pidloc="0" or recloc="0" or priloc="0" or clkloc="0" or pwdloc="0" or hotloc="0":errmsg="error in passed parameters in scheduling/login";goto loginEr:
::'grab values, based on start position thru the character just before start of next label:
::process_id = mid(@pm,pidloc+"5",recloc-(pidloc+"5")):
::recnum= mid(@pm,recloc+"5",priloc-(recloc+"5")):
::newpri= mid(@pm,priloc+"5",clkloc-(priloc+"5")):
::loginClk= mid(@pm,clkloc+"5",pwdloc-(clkloc+"5")):
::loginPass= mid(@pm,pwdloc+"5",hotloc-(pwdloc+"5")):
::hotval=mid(@pm,hotloc+"5","1"):
::return:
