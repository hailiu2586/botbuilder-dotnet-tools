setlocal
set TAG=%1
docker build -t hailiu2586/botbuild:%TAG% .
docker push hailiu2586/botbuild:%TAG%
endlocal
