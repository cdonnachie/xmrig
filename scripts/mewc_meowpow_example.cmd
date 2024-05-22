:: Example batch file for mining Meowcoin at a pool
::
:: Format:
::      xmrig.exe -a meowpow -o stratum.coinminerz.com:3546 -u <pool username/wallet> -p <pool password>
::
:: Fields:
::      pool address            The host name of the pool stratum or its IP address, for example stratum.coinminerz.com
::      pool port               The port of the pool's stratum to connect to, for example 3346. Check your pool's getting started page.
::      pool username/wallet    For most pools, this is the wallet address you want to mine to. Some pools require a username
::      pool password           For most pools this can be just 'x'. For pools using usernames, you may need to provide a password as configured on the pool.
::
:: List of Meowcoin mining pools:
::      https://miningpoolstats.stream/meowcoin
::
:: Choose pools outside of top 5 to help Meowcoin network be more decentralized!
:: Smaller pools also often have smaller fees/payout limits.

cd /d "%~dp0"
:: Use this command line to connect to pool
xmrig.exe -a meowpow -o us-stratum.coinminerz.com:3346 -u WALLET_ADDRESS -p x --donate-level=0 --no-cpu --cuda
:: Use this command line to connect to solo
xmrig.exe -a meowpow -o us-stratum.coinminerz.com:3546 -u WALLET_ADDRESS -p x --donate-level=0 --no-cpu --cuda

pause
