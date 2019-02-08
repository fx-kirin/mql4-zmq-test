## 注意書き

この記事はMT4のBuild419を対象としたものです。2019年にもなってこんな化石みたいに古いMT4を使っているのは私ぐらいしかいないんじゃないかと思う次第ですが、ご了承ください。最近のMT4のほうが言語の充実などもあり、優秀みたいですね。

## ZMQ をMT4で動かす

注書きにあるように、バージョンが古いから情報の検索が難しいんですが、github頼みでなんとかレポジトリがいくつか見つかりました。

[bm url="https://github.com/dingmaotu/mql-zmq" description="ZMQ binding for the MQL language (both 32bit MT4 and 64bit MT5) - dingmaotu/mql-zmq"]dingmaotu/mql-zmq: ZMQ binding for the MQL language (both 32bit MT4 and 64bit MT5)[/bm]

多分現行のバージョンで一番良いのがこれですね。最新版のMT4用にクラスとか使ってしっかり書いてありました。ただ、build419では動かない、もしくは動かすが大変。DLLの呼び出しに構造体とか使ってる時点でアウトです。

[bm url="https://github.com/OpenTrading/OTMql4Zmq" description="Open Trading Metatrader 4 ZeroMQ Bridge. Contribute to OpenTrading/OTMql4Zmq development by creating an account on GitHub."]OpenTrading/OTMql4Zmq: Open Trading Metatrader 4 ZeroMQ Bridge[/bm]

これは下に書くmql4zmqを最新バージョンで動かすためにフォークしたプロジェクトっぽい。このプロジェクト曰く、安定版であるZeroMQ 2.2 は現行バージョンでも後方互換されているとのこと。

[bm url="https://github.com/AustenConrad/mql4zmq" description="MQL4 bindings for ZeroMQ. Contribute to AustenConrad/mql4zmq development by creating an account on GitHub."]AustenConrad/mql4zmq: MQL4 bindings for ZeroMQ[/bm]

コミット履歴に2012年のものがある！これだ！とこれをベースに使っていくことにしました。ただ、ZMQのバージョンが2.1.4と少し心もとない。どうやら、OTMql4Zmqで使われているDLLとほとんど一緒みたいだったので、OTMql4Zmqからバージョン2.2のDLLを持ってきて、mql4zmqに上書きしました。

## exampleを参考に実装していく。

mql4zmqのexampleを参考に実装していくことになるのですが、そこのexampleがrubyのzmqを使って通信するサンプルしかおいていなく、今のLinuxに入っているrubyだと`gem i zmq`してもコンパイルエラーで止まってしまい、そのままでテストができないというつらい状況でした。rubyのzmqのバージョン2.1.4だし。そんなコンパイル環境を現環境に入れたくない。ということで、MQLを書き直してMQL上だけでテストを試みることになるのですが、ここでもまたハマる現象が現れます。

## Wine 環境でZMQを使うときにはまること

- Wine側のMQLから一度使ったポートはなかなか開放されない
 - どうしても使えない場合は `wineserver -k` をしてwinewerver を殺してください。
- Wine側でPUSHPULL用にバインドしたポートを、ポート開放してからPUBSUB用に使おうとしても動かない

## pyzmqではまったこと。

- pyzmq 17.0.0 は zmq 2.2 とPUBSUB する際、zmq側からSubscribeできない。
 - pyzmq 17.1.2を使うと直った。


## コードとか。

[bm url="https://github.com/fx-kirin/mql4-zmq-test" description="Test zmq on MT4 with MT4 Build 419. Contribute to fx-kirin/mql4-zmq-test development by creating an account on GitHub."]fx-kirin/mql4-zmq-test[/bm]

ここにおいておきます。
