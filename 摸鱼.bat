@echo off
chcp 65001 >nul
title building kernel 6.8.12
color 0B

rem ============================================================
rem   LOOK BUSY v3.3  --  devops/sysadmin logs, echo-only.
rem   Idle 2min (no mouse move) -> auto fullscreen.
rem   Stop: close the window, or press Ctrl+C
rem ============================================================

echo.
echo  ============================================================
echo    make -j16 world  kernel build
echo    branch main  commit %RANDOM%a%RANDOM%f
echo    toolchain clang-18  target x86_64
echo  ============================================================
echo.

rem grab this cmd process own PID
for /f "tokens=2 delims=," %%A in ('tasklist /FI "IMAGENAME eq cmd.exe" /FO CSV /NH') do set MYPID=%%A
rem launch idle detector once, passing our PID
if not defined DET_START (
  set DET_START=1
  if exist "%~dp0_lookbusy_idle.ps1" (
    start "" /min powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0_lookbusy_idle.ps1" %MYPID%
  )
)

:mainloop
set /a idx=%RANDOM% %% 72

if %idx%==0  echo [%time%] CC      drivers/gpu/drm/%RANDOM%/panel.c
if %idx%==1  echo [%time%] LD      vmlinux.o   +%RANDOM%KB
if %idx%==2  echo [%time%] SYSMAP  System.map   142%RANDOM% symbols
if %idx%==3  echo [%time%] MODPOST Module.symvers
if %idx%==4  echo [%time%] install -m 644 bzImage to /boot/vmlinuz-6.8.12
if %idx%==5  echo [%time%] depmod  6.8.12-generic
if %idx%==6  echo [%time%] update-initramfs -u -k 6.8.12-generic
if %idx%==7  echo [%time%] docker pull gcr.io/buildpacks/builder
if %idx%==8  echo [%time%] digest sha256 a1%RANDOM%c9d2 from remote
if %idx%==9  echo [%time%] running container id f%RANDOM%e
if %idx%==10 echo [%time%] kubectl apply -f deploy/prod/-R
if %idx%==11 echo [%time%] deployment settlements scaled to %RANDOM%
if %idx%==12 echo [%time%] pod/%RANDOM%-h4k2 Running 1/1 Ready
if %idx%==13 echo [%time%] ingress re-api configured
if %idx%==14 echo [%time%] terraform plan 12 to add 3 to change
if %idx%==15 echo [%time%] terraform apply module.vpc.aws_route
if %idx%==16 echo [%time%] aws s3 cp --recursive dist/ s3://assets-prod/
if %idx%==17 echo [%time%] upload 1%RANDOM% objects transfer OK
if %idx%==18 echo [%time%] psql -U svc -c VACUUM ANALYZE orders
if %idx%==19 echo [%time%] index scan orders_created_idx cost 0.42
if %idx%==20 echo [%time%] BEGIN LOCK TABLE ledger
if %idx%==21 echo [%time%] COMMIT transaction_id %RANDOM% ok
if %idx%==22 echo [%time%] git fetch origin --prune
if %idx%==23 echo [%time%] git rebase -i HEAD~%RANDOM%
if %idx%==24 echo [%time%] git push --force-with-lease origin main
if %idx%==25 echo [%time%] npm run build webpack 5.91
if %idx%==26 echo [%time%] chunk %RANDOM%.js %RANDOM% KiB gzip
if %idx%==27 echo [%time%] nvm exec 18.20.3 node server.mjs
if %idx%==28 echo [%time%] eslint src/ --fix
if %idx%==29 echo [%time%] rm -rf node_modules/.cache
if %idx%==30 echo [%time%] systemctl restart postgresql.service
if %idx%==31 echo [%time%] journalctl -u nginx -f
if %idx%==32 echo [%time%] 200 GET /api/health latency %RANDOM%ms
if %idx%==33 echo [%time%] ssh bastion -N -L 5432 db.internal 5432
if %idx%==34 echo [%time%] rsync -avz --delete ./build/ user@host /var/www/
if %idx%==35 echo [%time%] sent %RANDOM% bytes received %RANDOM% bytes
if %idx%==36 echo [%time%] tail -f /var/log/syslog
if %idx%==37 echo [%time%] grep -rn race src/ include *.rs
if %idx%==38 echo [%time%] cargo build --release compiling crate v0.%RANDOM%.0
if %idx%==39 echo [%time%] rustc 32 codegen units lto fat
if %idx%==40 echo [%time%] cmake --build . --target install -j12
if %idx%==41 echo [%time%] linked gtest passed %RANDOM% assertions
if %idx%==42 echo [%time%] load avg %RANDOM% cpu %RANDOM% pct
if %idx%==43 echo [%time%] free -h used %RANDOM%G buff/cache %RANDOM%M
if %idx%==44 echo [%time%] df -h root used %RANDOM% pct
if %idx%==45 echo [%time%] iptables -L -n -v %RANDOM% chains
if %idx%==46 echo [%time%] netstat -tulpn grep 443 LISTEN
if %idx%==47 echo [%time%] dig +short api.example.com TTL %RANDOM%
if %idx%==48 echo [%time%] curl -sI https api v2 HTTP2 200
if %idx%==49 echo [%time%] openssl x509 -text -noout TLS 1.3
if %idx%==50 echo [%time%] certbot renew --dry-run ok
if %idx%==51 echo [%time%] gzip -dc dump.sql mysql -u root app
if %idx%==52 echo [%time%] mysqldump --single-transaction app
if %idx%==53 echo [%time%] redis-cli --scan session %RANDOM% keys
if %idx%==54 echo [%time%] kafka-console-consumer topic events
if %idx%==55 echo [%time%] GRANT SELECT ON ALL TABLES
if %idx%==56 echo [%time%] EXPLAIN ANALYZE queries
if %idx%==57 echo [%time%] strace -c -p %RANDOM%
if %idx%==58 echo [%time%] perf record -g -p %RANDOM%
if %idx%==59 echo [%time%] lsof -iTCP -sTCP LISTEN %RANDOM% sockets
if %idx%==60 echo [%time%] chmod 600 ~/.ssh/id_ed25519
if %idx%==61 echo [%time%] keytool -genkeypair -alias prod
if %idx%==62 echo [%time%] mvn -DskipTests clean package SUCCESS
if %idx%==63 echo [%time%] gradle assembleRelease %RANDOM% tasks
if %idx%==64 echo [%time%] apt-get update -qq
if %idx%==65 echo [%time%] snap refresh channel stable
if %idx%==66 echo [%time%] crontab -l next run in %RANDOM% min
if %idx%==67 echo [%time%] ansible-playbook site.yml --limit prod -v
if %idx%==68 echo [%time%] salt state.highstate
if %idx%==69 echo [%time%] dd if dev/zero of test.bin bs 1M
if %idx%==70 echo [%time%] generated %RANDOM% MiB throughput high
if %idx%==71 echo [%time%] hexdump -C core.dump

ping 127.0.0.1 -n 3 >nul
goto mainloop
