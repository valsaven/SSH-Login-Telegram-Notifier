# SSH Login Telegram Notifier

This script sends a Telegram notification whenever someone logs into your server via SSH.

## Requirements

- Bash
- curl

## Instructions

1. **Create a Telegram bot**: You can do this via [BotFather](https://t.me/BotFather).
2. **Create a Telegram channel**: This can be private or public, depending on your preference. This is where the alerts will be sent.
3. **Get the bot updates**: Create a URI in the following format:

    ```bash
    https://api.telegram.org/bot*****:***-*****************/getUpdates
    ```

    and invoke it.
4. **Add your bot to the channel**: This will allow the bot to send messages to the channel.
5. **Get the channel ID**: You can do this by visiting `https://api.telegram.org/bot*****:***-*****************/getUpdates` again. The channel ID will be listed there.
6. **Register at IPInfo**: You can do this at [ipinfo.io](https://ipinfo.io/). This will give you an API token.
7. **Update the script**: Fill in the variables in the script with your Telegram bot token, channel ID, and IPInfo token.
8. **Make the script executable**: You can do this with the following command:

    ```bash
    chmod +x ssh_notifier.sh
    ```

9. **Test the script**: Run the script and check that everything works correctly.
10. **Update the SSHD PAM configuration**: Add the following line to the end of `/etc/pam.d/sshd`:

    ```bash
    session optional pam_exec.so type=open_session seteuid /full/path/to/ssh_notifier.sh
    ```

    This will run the script whenever someone logs into your server via SSH.

Now, try connecting to your server via SSH. You should receive a notification in your Telegram channel. Enjoy your new notification system!
