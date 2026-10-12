# Maintainer: TexnoM <https://github.com/TexnoM>
pkgname=roblox-linux-blocker
pkgver=1.2.0
pkgrel=1
pkgdesc="Kernel-level blocker for Roblox and Sober with Telegram parental controls"
arch=('any')
url="https://github.com/TexnoM/RobloxLinuxBlocker"
license=('AGPL-3.0-or-later')
depends=('bash' 'iptables' 'iproute2' 'python')
optdepends=(
    'systemd: for automatic startup and Telegram bot background services'
)
backup=(
    'etc/rlb/roblox_ips.txt'
    'etc/rlb/roblox_domains.txt'
    'etc/rlb/bot_config.json'
)

package() {
    # If building directly from repo folder
    if [[ -d "$srcdir/$pkgname-$pkgver" ]]; then
        cd "$srcdir/$pkgname-$pkgver"
    elif [[ -f "${startdir:-.}/bin/rlb" ]]; then
        cd "${startdir:-.}"
    fi

    # Install binaries
    install -Dm755 bin/rlb "$pkgdir/usr/bin/rlb"
    install -Dm755 bin/rlb-telegram-bot "$pkgdir/usr/bin/rlb-telegram-bot"

    # Install configuration data
    install -Dm644 data/roblox_ips.txt "$pkgdir/etc/rlb/roblox_ips.txt"
    install -Dm644 data/roblox_domains.txt "$pkgdir/etc/rlb/roblox_domains.txt"
    install -Dm600 data/bot_config.json "$pkgdir/etc/rlb/bot_config.json"
    install -Dm644 data/stats.json "$pkgdir/etc/rlb/stats.json"

    # Install systemd service units
    install -Dm644 systemd/rlb.service "$pkgdir/usr/lib/systemd/system/rlb.service"
    install -Dm644 systemd/rlb-bot.service "$pkgdir/usr/lib/systemd/system/rlb-bot.service"

    # Install license and documentation
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
    install -Dm644 README.uk.md "$pkgdir/usr/share/doc/$pkgname/README.uk.md"
}
