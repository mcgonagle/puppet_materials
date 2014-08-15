#!/usr/bin/python -O
#
# Framework for delivering email to members
# Treet: It's like spam, but its not.
#
# http://en.wikipedia.org/wiki/Treet
#
# $Id: treet_pusher.py,v 1.9 2010/06/07 14:24:12 wflynn Exp $
#
import sys, smtplib, MimeWriter, base64, StringIO
from optparse import OptionParser

SMTPSERVER = 'localhost'
SENDER = 'notifications@manhunt.net'
RECIPIENT = 'care@online-buddies.com'
TEMPLATEDIR='/usr/local/manhunt/treet_templates'
MONITOR = 'donotreply@manhunt.net'
ERRORSTO = 'notification-errors@manhunt.net'

try:
    sys.path.append(TEMPLATEDIR)
except:
    print "Don't know where to find any templates:", sys.exc_info()[:2]
    raise

def send_msg(username="MANHUNTServiceMan", userid="1", language="en", email=[RECIPIENT], template=None, subject=None, filename=None):
    if template:
        (message_subject, message_body) = get_content(language, template)
    elif (subject and filename):
        message_subject = subject
        try:
            message_body=open(filename).read()
        except:
            print "Unexpected File Read error:", sys.exc_info()[:2]
            raise
    else:
        print "No content specified. Exiting."
        sys.exit(2)

    message = StringIO.StringIO()
    writer = MimeWriter.MimeWriter(message)
    writer.addheader('MIME-Version', '1.0')
    writer.addheader('Content-Language', language)
    writer.addheader('Errors-To', ERRORSTO)
    writer.addheader('Reply-To', MONITOR)
    writer.addheader('Subject', message_subject)
    writer.addheader('To', email)
    writer.addheader('X-MH-UID', str(userid))
    writer.startmultipartbody('mixed')

    # start off with a text/plain part
    part = writer.nextpart()
    body = part.startbody('text/plain')
    body.write(message_body)

#     # How one would ad further encoded content:
#     part = writer.nextpart()
#     part.addheader('Content-Transfer-Encoding', 'base64')
#     body = part.startbody('image/jpeg; name=kitten.jpg')
#     base64.encode(open('kitten.jpg', 'rb'), body)

    # finish off
    writer.lastpart()

    # deliver it
    deliver_msg(email, message)


def deliver_msg(recipients, message=None):
    if __debug__:
        # print it
        print "To:\n%s\n" % str(recipients)
        print "Message:\n%s\n" % message.getvalue()
    else:
        # send it
        smtp = smtplib.SMTP(SMTPSERVER)
        try:
            smtp.sendmail(SENDER, recipients, message.getvalue())
        except:
            print "Unexpected SMTP error:", sys.exc_info()[:2]
            raise
        smtp.quit()

def get_content(language="en", contentfile=None):
    try:
        content = __import__(contentfile).content
    except:
        raise
    try:
        subject = __import__(contentfile).subject
    except:
        raise
    if language in content:
        msg_body=content[language]
    else:
        msg_body=content["en"]
    if language in subject:
        msg_subj=subject[language]
    else:
        msg_subj=subject["en"]

    return(msg_subj, msg_body)

def main():
    usage = "usage: %prog [options]\n\tNote: --template or --subject and --filename are mutually exclusive\n\tMulti-word subjects must be quoted"
    parser = OptionParser(usage)
    parser.add_option("-e", "--email", dest="email", help="user's EMAIL")
    parser.add_option("-f", "--filename", dest="filename", help="single message content FILENAME")
    parser.add_option("-i", "--userid", dest="userid", help="user's USERID")
    parser.add_option("-l", "--language", dest="language", default="en", help="user's LANGUAGE")
    parser.add_option("-s", "--subject", dest="subject", help="single message SUBJECT")
    parser.add_option("-t", "--template", dest="template", help="email content TEMPLATE")
    parser.add_option("-u", "--username", dest="username", help="user's USERNAME")
    (options, args) = parser.parse_args()

    if not (options.username and options.userid and options.language and options.email and (options.template or (options.filename and options.subject))):
        parser.print_help()
        sys.exit(2)
    else:
        send_msg(options.username, options.userid, options.language, options.email, options.template, options.subject, options.filename)
    sys.exit()

if __name__ == "__main__":
    main()
