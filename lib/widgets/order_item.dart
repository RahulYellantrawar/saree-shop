import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem(this.order, {super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return
      AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? min(widget.order.products.length * 20 + 110, 200) : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\u{20B9}${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded ? min(widget.order.products.length * 20 + 10, 100) : 0,
              child: ListView(
                children: widget.order.products
                    .map((prod) => Column(
                      children: [
                        Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                        Flexible(
                          child: Text(
                            prod.title,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '${prod.quantity} x \u{20B9}${prod.price}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        )
                  ],
                ),
                        const SizedBox(height: 10,)
                      ],
                    ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
