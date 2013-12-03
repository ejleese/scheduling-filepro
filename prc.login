:'##############################################################:'# 10-3-13 ejl handle login request before reprioritizing allowed:
:'# ripped from issues/post::
::declare process_id(8,.0); process_id = @pm:
::declare extern recnum; recnum=@pw:
::declare newpri(4,.0); newpri=@px:
::declare extern userlogin;:
::declare errmsg:
::declare global loginClk(4,.0), loginPass(3,*):
::loginClk=@py; loginPass=@pz:
::' system "echo"<@pm<","<@pw<","<@px<","<@py<","<@pz<"| mutt -s login_vars ericl@borisch.com":
DoLogin:'##############################################################:'# login:
::export ascii htm = ("/appl/fpmerge/schedreprior_"{process_id{".pout") R=\n F=,:
::lookup plk = person  K=(loginClk) i=A -nx:
:not plk:errmsg="login failure"; goto loginEr:
:plk(12) ne loginPass:errmsg = "login failure"; goto loginEr:
::userlogin=plk(32):
:'user exists with correct pwd. now make sure they have permission:'to use reprioritize function:
::lookup scx = scx_filename  k=(plk(32)&"scheduling    "&"reprior") i=E -nx:
:not scx:errmsg="You do not have permission for this feature."; goto loginEr:
:'### LOGIN AUTHENICATION SUCCESSFUL...::
::htm(1)="success"; htm(2)="":
::write htm; close htm; sync:
::call "setPriority":
::end:
loginEr:'### HANDLE FAILED AUTHENICATION::
::htm(1)=errmsg:
::htm(2)="":
::write htm; close htm; sync:
::end:
