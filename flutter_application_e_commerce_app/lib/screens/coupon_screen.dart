import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/provider/provider_food.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            hoverColor: Colors.white,
            highlightColor: const Color.fromARGB(255, 255, 208, 137),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.orange,
            )),
        title: const Text(
          'Coupon',
          style: TextStyle(
              color: Color.fromARGB(255, 235, 141, 0),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Consumer<ProviderFood>(
        builder: (context, providerFood, child) {
          if (providerFood.listCoupons.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.image_search,
                    size: 70,
                    color: Colors.orange,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    child: const Text(
                      'Không tìm thấy mã giảm giá nào',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const Text(
                    'Hãy đặt hàng để nhận mã giảm giá',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: providerFood.listCoupons.length,
              itemBuilder: (context, index) {
                final item = providerFood.listCoupons[index];
                return Container(
                  height: 150,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 197, 197, 197)
                            .withOpacity(
                                0.5), // Màu của boxShadow và độ trong suốt
                        spreadRadius: 5, // Bán kính mở rộng của boxShadow
                        blurRadius: 7, // Bán kính mờ của boxShadow
                        offset: const Offset(0,
                            3), // Độ dịch chuyển của boxShadow theo trục x và y
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'img/coupon-svgrepo-com.png',
                        width: 120,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 100,
                              child: Text(
                                'Giảm \$${item.price}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 21),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            const TextSpan(text: 'Trạng thái: '),
                            TextSpan(
                                text:
                                    item.isUse ? 'Đã sử dụng' : 'Chưa sử dụng',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ]))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Mã giảm giá :'),
                          Text(
                            item.coupon,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
