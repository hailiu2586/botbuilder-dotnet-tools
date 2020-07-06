#!/bin/bash
qna=$1
dialog=$(basename $qna .qna)
bf qnamaker:build -i $qna -o /bot/Dialogs/generated --botName $BOT_NAME-$dialog --log --subscriptionKey $AZ_QNA_SUB_KEY
echo qna $dialog built
