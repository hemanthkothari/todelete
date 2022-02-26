import urllib
import json
import traceback
import logging
import optparse
import os
import sys

if __name__ == '__main__':
    _logger = logging.getLogger("stackLog")
    logging.basicConfig()
    parser = optparse.OptionParser(usage=os.path.basename(__file__)+' [options]',formatter=optparse.TitledHelpFormatter(width=75))
    parser.add_option("-i", "--componentID", dest="componentID", help="Input the component id")
    parser.add_option("-r", "--rating", dest="rating", help="Input the rating number")
    settings, args = parser.parse_args(sys.argv)

    if settings.componentID == None or settings.rating == None:
        sys.exit("error: Please input the component id and rating number")
    if int(settings.rating)  > 4 or int(settings.rating) < 0:
        sys.exit("error: The rating number must be >=0 and <=4")
    try:
        data = urllib.urlencode({'component_id': settings.componentID})
        r = urllib.urlopen('http://swstack.natinst.com/get_component_instances', data)
        allInstancesInfoMap = json.loads(r.read())
        if not allInstancesInfoMap['ok']:
            raise Exception('Get Component %d Instances Status Error: "%s"'% (int(settings.componentID), allInstancesInfoMap['ok']))

        for allInstancesInfo in allInstancesInfoMap['component_instances']:
            try:
                data = urllib.urlencode({'component_instance_id': allInstancesInfo['id']})
                r = urllib.urlopen('http://swstack.natinst.com/get_component_instance_details', data)
                ciInfoMore = json.loads(r.read())
                if not ciInfoMore['ok']:
                    raise Exception('Get component instance %d more information Status Error: "%s"'% (allInstancesInfo['id'], ciInfoMore['ok']))
                if ciInfoMore['component_instance']['rating'] >= int(settings.rating):
                    print ciInfoMore['component_instance']['path']
                    break
            except Exception, error:
                _logger.error("Failed to get more information of component instance %d: %s" % (allInstancesInfo['id'], error))
    except Exception:
        _logger.error("Failed to get all instances of component %d.\n%s" % (int(settings.componentID), traceback.format_exc()))