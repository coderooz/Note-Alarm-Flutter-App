# Security Policy

## Supported Versions

Only the latest release is actively supported with security updates.

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |
| < latest | :x:               |

## Reporting a Vulnerability

If you discover a security vulnerability, **please do not open a public issue**.

Instead, report it privately by emailing
[contact@coderooz.in](mailto:contact@coderooz.in) with the subject
`[Security] <brief description>`.

Please include:

- A description of the vulnerability
- Steps to reproduce (if possible)
- Affected versions
- Any suggested fixes (optional)

### What to expect

- **Acknowledgment:** You'll receive an acknowledgment within 48 hours.
- **Status updates:** You'll be kept informed of progress toward a fix.
- **Disclosure:** Once a fix is released, the vulnerability will be disclosed
  responsibly with credit to the reporter (unless anonymity is requested).

## Security Notes

- This app stores all data **locally** on the device via `shared_preferences`.
  No data is transmitted to any server.
- The app requests notification and exact-alarm permissions solely for alarm
  functionality. These can be revoked in device settings at any time.
- Do not commit secrets, API keys, or keystore files to the repository.
  Release signing credentials belong in `android/key.properties` (git-ignored).