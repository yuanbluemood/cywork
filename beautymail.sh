
#!/bin/bash
##@ shell name: beautymail.sh
##@ authore:    yuanbluemood
##@ function:   make mail info looks better by html
##@ date:       2012-11-14 V1.0 
##@ date:       2012-11-15 V2.0 add file in mail

title="XX日志备份情况："
topline="日志类型;日志量;文件数"
html='/tmp/info.html'
mail='xxxx@xx.com'
subject='【报警输出优化】Test'

while getopts "a:T:t:H:m:s:h" Option
do
    case $Option in
        a) addfile="$OPTARG";;
        T) title="$OPTARG";;
        t) topline="$OPTARG";;
        H) html="$OPTARG";;
        m) mail="$OPTARG";;
        s) subject="$OPTARG";;
        h)
            echo "Usage: beautymail [-a addfile] [-T title-in-mail] [-t topline] [-H html-location] [-m mail-addr] [-s subject] content-file"
            exit
    esac
done
shift $(($OPTIND - 1))

function init(){

    chars=$(echo $topline|wc -c)
    width=$(echo $chars*20|bc)
cat >$html<<EOF
<font color = green >$title</b></font>
"/usr/bin/beautymail" 129L, 3623C                                                                                 1,1           Top
        echo "" >> $MSG_FILE
        /usr/bin/base64 $8 >> $MSG_FILE
    fi

    cat $MSG_FILE | /usr/lib/sendmail -t
}

##! @TODO: 发送邮件
##! @AUTHOR: http://neoremind.net/2011/02/linux_sendmail_attachment_mutt/
##! @VERSION: 1.0
##! @IN: 
##! @OUT: 
function sendMail()
{
        echo "Sending $Subject mail from $From to $To"

        from="root@$(hostname)"
        to="$1"
        subject="$2"
        content_type="text/html"
        MAIL_HTML="$3"
        body="$(cat $MAIL_HTML)"
        attach_type="text/csv"
        attach_path="$4"
        attach_name=$(echo "$attach_path"|awk -F'/' '{print $NF".txt"}')
        SendMailMultiMediaAttach "$from" "$to" "$subject" "$content_type" "$body" "$attach_type" "$attach_name" "$attach_path"
        echo "Send mail done."
}

echo $addfile
if [ -z "$addfile" ];then
    sendMail "$mail" "$subject" "$html"
else
    sendMail "$mail" "$subject" "$html" "$addfile"
fi
    #mutt -e 'my_hdr Content-Type: text/html' "$mail" -s "$subject" < "$html";
