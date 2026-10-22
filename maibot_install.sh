echo "
	========							========
		此脚本会联网下载maibot和napcat(可选)，请确认继续或者退出
				适用于使用apt的linux发行版	by Aza/xz
	========							========
"
read -p "Y/n: " flag
if [ -z "$flag" ]; then
	echo "===Start==="
elif [ "$(printf "%s" \"$flag\" | tr [:upper:] [:lower:])" == "y" ]; then
	echo "===Start==="
else
	exit 0
fi

sudo apt update

if [ -z "$(wget -V | grep \"GNU Wget\")" ];then
	sudo apt install wget -y
fi
wget -qO- https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
uv python install 3.12

maibotdir=~
cd "$maibotdir/"
maibotdir_="$(pwd)"
read -p "安装路径(默认$maibotdir_/MaiBot): " maibotdir
if [ -z "$maibotdir" ];then
	maibotdir=$maibotdir_
	cd "$maibotdir/"
else
	cd "$maibotdir/"
	maibotdir="$(pwd)"
fi
if [ -z "$(git -v | grep \"git version\")" ];then
	sudo apt install git -y
fi
git clone https://github.com/Mai-with-u/MaiBot.git
cd MaiBot
uv sync --python 3.12
echo "cd $maibotdir/MaiBot/ && uv run --python 3.12 bot.py&" >"$maibotdir/run_maibot.sh"
chmod +x "$maibotdir/run_maibot.sh"

cd "$maibotdir/"
echo "安装完成，第一次启动可能需要应用环境变量 \"source $HOME/.local/bin/env\""
echo "使用 \"$maibotdir/run_maibot.sh\" 命令启动"
echo "第一次需要使用 \"uv run --python 3.12 bot.py\" 手动启动并同意MaiCat用户协议后才能使用脚本一键启动"
echo "配置文件修改功能开发中ing..."


read -p "是否安装NapCat(使用NapCat官方安装脚本)    Y/n: " flag_napcat
if [ -z "$flag_napcat" ]; then
        echo "===Start==="
elif [ "$(tr [:upper:] [:lower:]) \"$flagnapcat\"" == "y" ]; then
        echo "===Start==="
else
        exit 0
fi
wget -O "$maibotdir/napcat.sh" https://raw.githubusercontent.com/NapNeko/NapCat-Installer/main/script/install.sh &&
bash napcat.sh --docker n --cli y --github-proxy 0
