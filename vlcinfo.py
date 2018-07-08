import os, dbus, argparse, urlparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('-t', '--title', action='store_true', help="print the title of the video played by vlc")
    parser.add_argument('-l', '--length', action='store_true', help='Get the percentage of video played')
    args = parser.parse_args()
    try:
        player = dbus.SessionBus().get_object('org.mpris.MediaPlayer2.vlc','/org/mpris/MediaPlayer2')
        metadata = player.Get('org.mpris.MediaPlayer2.Player', 'Metadata', dbus_interface='org.freedesktop.DBus.Properties')
        if args.title:
            if 'xesam:title' in metadata:
                print str(metadata['xesam:title'])
            else:
                filename = os.path.basename(urlparse.urlparse(str(metadata['xesam:url'])).path)
                filename = filename[0:filename.rfind(".")].replace("%20"," ")
                filename = filename[0:18]
                print filename
        if args.length:
            print int(player.Get('org.mpris.MediaPlayer2.Player', 'Position', dbus_interface='org.freedesktop.DBus.Properties')*100/metadata['mpris:length'])
    except:
        pass