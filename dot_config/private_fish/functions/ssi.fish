function ssi
    if test (count $argv) -eq 0
        echo "No arguments supplied"
        return 1
    end

    if string match -q -r '^[0-9]+$' $argv[1]
        # $argv[1] is a number, use sshpass with ic prefix
        sshpass -e ssh ydadmin@"ic$argv[1].ivcon.atriskcloud.net"
    else
        # $argv[1] is a hostname/string, use regular ssh
        ssh $argv[1]
    end
end
