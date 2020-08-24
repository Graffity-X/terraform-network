
##############################
### publicネットワーク
# マルチAZ化する。この場合、CIDRブロックは一致してはいけない
resource "aws_subnet" "public_web" {
  vpc_id = aws_vpc.vpc.id
  # Classless Inter-Domain Routing
  # サブネットマスクのbit数によって、右側を固定し、余った部分を自由に使える。
  #https://web-camp.online/lesson/curriculums/191/contents/1197
  cidr_block = "10.0.1.0/24"
  #  "ap-northeast-1a",
  #  "ap-northeast-1c"
  # https://dev.classmethod.jp/articles/one-liner-for-getting-available-az/
  # availability zoneをまたがったサブネットは作成不可能
  availability_zone = "ap-northeast-1a"
  # これをtrueにすると、そのサブネットで起動したインスタンスにpublicIPを自動で割り当ててくれる。
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.name}-public-0"
  }
}

resource "aws_subnet" "public_https" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = true

   tags = {
    "Name" = "${var.name}-public-1"
  }
}

#######################################
########## webのルートテーブル ##########
# gwだけでは通信できないので、ルーティング情報を管理するためのルートテーブルが必要
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  # ルートテーブルの1レコードに該当。
  # VPC以外の通信を(gw経由で)インターネットへデータを流すために、デフォルトルートをcidr_blockに指定。
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    "Name" = "${var.name}-public-rtb"
  }
}

# 「どのルートテーブルを通ってルーティングするのか」はサブネット単位で判断
# より、サブネットとルートテーブルを関連付け
# (関連付けを忘れるとデフォルトルートテーブルが使われてしまい、編集とかができなくなるのでなるべく紐付ける。)
resource "aws_route_table_association" "public_a" {
  subnet_id = aws_subnet.public_web.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id = aws_subnet.public_https.id
  route_table_id = aws_route_table.public_rtb.id
}


##############################
### privateネットワーク ########
# マルチAZ化、NATゲートウェイも冗長化
resource "aws_subnet" "private_db1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.65.0/24"
  availability_zone = "ap-northeast-1a"
  # privateはpublicIPは不要
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.name}-private-db1"
  }
}

resource "aws_subnet" "private_db2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.66.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.name}-private-db2"
  }
}

#########################
##### ルートテーブル ######
resource "aws_route_table" "private_db1" {
  vpc_id = aws_vpc.vpc.id

  route {
    # nat_gateway_id = aws_nat_gateway.natgw.id # ここでnat_gateway_idを指定
    gateway_id = "${aws_internet_gateway.gw.id}"
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    "Name" = "${var.name}-private-0"
  }
}

resource "aws_route_table" "private_db2" {
  vpc_id = aws_vpc.vpc.id

  route {
    # nat_gateway_id = aws_nat_gateway.natgw.id # ここでnat_gateway_idを指定
    gateway_id = "${aws_internet_gateway.gw.id}"
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    "Name" = "${var.name}-private-1"
  }
}


resource "aws_subnet" "private_redis1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.67.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.name}-private-redis1"
  }
}


resource "aws_subnet" "private_redis2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.68.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.name}-private-redis2"
  }
}


resource "aws_route_table" "private_redis1" {
  vpc_id = aws_vpc.vpc.id

  route {
    # nat_gateway_id = aws_nat_gateway.natgw.id # ここでnat_gateway_idを指定
    gateway_id = "${aws_internet_gateway.gw.id}"
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    "Name" = "${var.name}-private-redis1"
  }
}


resource "aws_route_table" "private_redis2" {
  vpc_id = aws_vpc.vpc.id

  route {
    # nat_gateway_id = aws_nat_gateway.natgw.id # ここでnat_gateway_idを指定
    gateway_id = "${aws_internet_gateway.gw.id}"
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    "Name" = "${var.name}-private-redis2"
  }
}

resource "aws_route_table_association" "private_redis1" {
  subnet_id = aws_subnet.private_redis1.id
  route_table_id = aws_route_table.private_redis1.id
}

resource "aws_route_table_association" "private_redis2" {
  subnet_id = aws_subnet.private_redis2.id
  route_table_id = aws_route_table.private_redis2.id
}

#############################
### セキュリティグループredis

resource "aws_security_group" "redis" {
  name        = "redis_server"
  description = "It is a security group on redis of vpc."
  vpc_id      = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.name}-redis"
  }
}

resource "aws_security_group_rule" "redis" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app.id
  security_group_id        = aws_security_group.redis.id
}

resource "aws_elasticache_subnet_group" "subnet" {
  name = "${var.name}-redissubnet"
  description = "It is a redis subnet group on vpc."
  subnet_ids = [aws_subnet.private_redis1.id, aws_subnet.private_redis2.id]
}





# ############################
# ####### NATゲートウェイ。
# #privateネットワークからインターネットにアクセス可能にする。
# # つまりprivateIPをpublicIPにしてくれる
# # NATゲートウェイにはeipが必要。
# resource "aws_eip" "nat_gateway_0" {
#   vpc = true
#   depends_on = [aws_internet_gateway.gw]
# }

# resource "aws_eip" "nat_gateway_1" {
#   vpc = true
#   depends_on = [aws_internet_gateway.gw]
# }

# # eipやnatは暗黙的にgwに依存しているためdepends_onを定義
# resource "aws_nat_gateway" "natgw_0" {
#   allocation_id = aws_eip.nat_gateway_0.id
#   subnet_id = aws_subnet.public_0.id
#   depends_on = [aws_internet_gateway.gw]
# }

# resource "aws_nat_gateway" "natgw_1" {
#   allocation_id = aws_eip.nat_gateway_1.id
#   subnet_id = aws_subnet.public_1.id
#   depends_on = [aws_internet_gateway.gw]
# }