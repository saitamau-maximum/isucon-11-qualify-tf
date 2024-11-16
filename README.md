# ISUCON11予選をさくらのクラウドでやるためのterraform

Based on: https://github.com/yamamoto-febc/sacloud-terraform-isucon

## 使い方

### envs/*.tfvarsを作って必要な情報を書く

```sh
cp envs/example.tfvars envs/<your_env_name>.tfvars
```

```txt
team_name = ""
```

### variables.tfのpublic_key_pathを書き換える

```terraform
variable "public_key_path" {
  default = "<your_public_key_path>"
}
```

ここは`envs/*.tfvars`に書いてもいいです。

### terraformを実行する

```sh
terraform init
terraform workspace new <your_env_name> # or terraform workspace select <your_env_name>
terraform apply -var-file=envs/<your_env_name>.tfvars
```

ただし、実行には環境変数として`SAKURACLOUD_ACCESS_TOKEN`と`SAKURACLOUD_ACCESS_TOKEN_SECRET`が必要です。

### benchmarkerのIPアドレスを取得する

数分後、SSHでログインできるようになるので、以下のコマンドでbenchmarkerのIPアドレスを取得してください。

```sh
terraform output benchmarker_ip_address
```

### benchmarkerにログインする

```sh
ssh -i <your_private_key_path> ubuntu@<benchmarker_ip_address>
```

### benchmarkerでappのsystemdを破棄する

```sh
sudo systemctl stop    isuumo.go.service
sudo systemctl disable isuumo.go.service
```

これをやらないと、benchmarkerがappを起動してしまうため、パフォーマンスに影響が出る可能性があります。

### terraformを破棄する

```sh
terraform destroy -var-file=envs/<your_env_name>.tfvars
```

「ISUCON」は、LINE株式会社の商標または登録商標です。

### 3台構成でやる

地獄です、1台構成でやった方がいいと思いますよ。
[ここ](https://github.com/saitamau-maximum/isucon11-qualify-tf/tree/feat/3-clusters)に3台構成にしたものがあります。

`/etc/hosts`を[公式のISUCON11qのもの](https://github.com/isucon/isucon11-qualify/blob/1011682c2d5afcc563f4ebf0e4c88a5124f63614/docs/manual.md#etchosts-%E3%81%AA%E3%82%89%E3%81%B3%E3%81%AB-isucondition-1-3tisucondev-%E3%83%89%E3%83%A1%E3%82%A4%E3%83%B3%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6)に書き換えてください。

ベンチマークは以下のように実行してください。

```bash
./bench -all-addresses isucondition-1.t.isucon.dev -target isucondition-1.t.isucon.dev:443 -tls -jia-service-url http://172.0.0.1:4999
```

自分はこれでも1000点から点数が変わりませんでした。もし挑戦する人がいたら頑張って...
