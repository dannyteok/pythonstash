#/usr/bin/python

wiki = (
    "Works only with python2.7.x because twilio package is not available in version 3.5.x"
    "This is more about introducing the concept of class -- TwilioRestClient."
)



from twilio.rest import TwilioRestClient

## Your Accout SID aand AUTH Token from twilio.com/user/account
account_sid = "ACe4f11d3a776fdf4b7c5485e3deedb1e9" # Your Account SID from www.twilio.com/console
auth_token  = "dbac78e11263109e039b274388******"  # Your Auth Token from www.twilio.com/console

client = TwilioRestClient(account_sid, auth_token)

message = client.messages.create(
    body="Hello babe\n Shall we go out for a walk together later?\n I love you dearly, \nDT",
    to="+44792979****",    # Replace with your phone number
    from_="+441604420928") # Replace with your Twilio number

print(message.sid)