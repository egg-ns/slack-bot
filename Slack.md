# Slack MEMO

## Manifest

- Manifest JSON

```json
{
  "display_information": {
    "name": "socket-test"
  },
  "features": {
    "bot_user": {
      "display_name": "socket-test",
      "always_online": false
    },
    "shortcuts": [
      {
        "name": "問い合わせ",
        "type": "global",
        "callback_id": "socket-test-callback",
        "description": "あああ"
      }
    ]
  },
  "oauth_config": {
    "scopes": {
      "user": ["users:read"],
      "bot": [
        "app_mentions:read",
        "channels:read",
        "commands",
        "users:read",
        "chat:write"
      ]
    }
  },
  "settings": {
    "event_subscriptions": {
      "user_events": ["team_join"],
      "bot_events": ["app_mention", "channel_created"]
    },
    "interactivity": {
      "is_enabled": true
    },
    "org_deploy_enabled": false,
    "socket_mode_enabled": true,
    "token_rotation_enabled": false
  }
}
```

- Manifest YAML

```yaml
display_information:
  name: socket-test
features:
  bot_user:
    display_name: socket-test
    always_online: false
  shortcuts:
    - name: 問い合わせ
      type: global
      callback_id: socket-test-callback
      description: あああ
oauth_config:
  scopes:
    user:
      - users:read
    bot:
      - app_mentions:read
      - channels:read
      - commands
      - users:read
      - chat:write
settings:
  event_subscriptions:
    user_events:
      - team_join
    bot_events:
      - app_mention
      - channel_created
interactivity:
  is_enabled: true
org_deploy_enabled: false
socket_mode_enabled: true
token_rotation_enabled: false
```

## TOKEN

- (Basic Infomation)App-Level Token (socket mode token : token name=>自分で決めた)

-> Slack のクラウド上の自分のアプリへのアクセス TOKEN
xapp-1-A062SF7EGAC-6068629993685-477626d47e107c68a5219974ca1971ea9ce9c28a9762c136401d496bb7d4ee7d

- User OAuth TOKEN

-> User 権限への TOKEN
xoxp-811268029777-819189486229-6094655646624-1659e4bf12d9f1e4ae3bc6b160afb330

- Bot User OAuth TOKEN

-> Bot User 権限への TOKEN
xoxb-811268029777-6071567405539-FySP9p65RSi4uKbgIYJSCROt
