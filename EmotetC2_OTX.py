from OTXv2 import OTXv2
import json
import os


API_KEY = ''
pulse_id= ''
OTX_SERVER = 'https://otx.alienvault.com'

otx = OTXv2(API_KEY, server=OTX_SERVER)

x = "/root/Emotet/c2final.txt"


def get_c2():
    print 'Getting indicators for Emotet C2 pulse:'
    os.system('echo Getting IOCs from C2 Pulse at $(date +%Y-%m-%d_%H:%M:%S)  >> /root/Emotet/EmotetC2.log')
    indicators = otx.get_pulse_indicators(pulse_id=pulse_id)
    json_out = open('/root/Emotet/IOC_IP.json', 'a+')
    json_out.write('[')
    for indicator in indicators:
        file = open("/root/Emotet/c2final.txt", 'a')
        file.write(indicator['indicator'])
        file.write("\n")
        file.close()


def outurl_json(x):
    with open(x , 'r') as in_file:
        json_out = open('/root/Emotet/IOC_IP.json', 'a+')
        for line in in_file:
            obj = {u"type": "IPv4", u"indicator":  line.rstrip()}
            json_out.write(json.dumps(obj, indent=9))
            json_out.write(',\n')
        json_out.write(']')
        json_out.close()
        os.system('head -n -2 /root/Emotet/IOC_IP.json | sed -e "\$a }\n" | sed -e "\$a ]" >> /root/Emotet/IOC_IP2.json')


def update_pulse():
    print 'Updating indicators for Emotet C2 pulse:'
    os.system('echo Updating Emotet C2 Pulse at $(date +%Y-%m-%d_%H:%M:%S) >> /root/Emotet/EmotetC2.log')
    with open('IOC_IP2.json', 'r') as data_file:
        data = json.load(data_file)
        response = otx.replace_pulse_indicators(pulse_id, data)
        os.system('echo Done at $(date +%Y-%m-%d_%H:%M:%S) >> /root/Emotet/EmotetC2.log')
        #print 'Response: ' + str(response)


get_c2()
outurl_json(x)
update_pulse()
