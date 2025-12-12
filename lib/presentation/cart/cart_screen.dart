import 'package:adhesivepro/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [
    {
      "name": "Disolvente HACSA NF",
      "price": 35.50,
      "quantity": 1,
      "image": "https://hacsa.com.pe/wp-content/uploads/2024/12/disol3.png",
    },
    {
      "name": "Grass Sintético",
      "price": 42.00,
      "quantity": 2,
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/PEGAGRASS-1.png",
    },
    {
      "name": "Unitub Naranja",
      "price": 55.00,
      "quantity": 1,
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/UNITUB-NARANJA.png",
    },
  ];

  double get total {
    double suma = 0;
    for (var item in cartItems) {
      suma += item["price"] * item["quantity"];
    }
    return suma;
  }

  void incrementar(int index) {
    setState(() {
      cartItems[index]["quantity"]++;
    });
  }

  void disminuir(int index) {
    if (cartItems[index]["quantity"] > 1) {
      setState(() {
        cartItems[index]["quantity"]--;
      });
    }
  }

  final TextEditingController cardController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  // ----------- NUEVO: BottomSheet de Pago -------------
  void _openPaymentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            top: 3.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 3.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Método de pago",
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 2.h),

              // ---- Número de tarjeta ----
              TextField(
                controller: cardController,
                keyboardType: TextInputType.number,
                maxLength: 19,
                decoration: const InputDecoration(
                  labelText: "Número de tarjeta",
                  prefixIcon: Icon(Icons.credit_card),
                ),
                onChanged: (value) {
                  String numbers = value.replaceAll("-", "");
                  String formatted = "";

                  for (int i = 0; i < numbers.length; i++) {
                    if (i % 4 == 0 && i != 0) formatted += "-";
                    formatted += numbers[i];
                  }

                  cardController.value = TextEditingValue(
                    text: formatted,
                    selection:
                        TextSelection.collapsed(offset: formatted.length),
                  );
                },
              ),

              // ---- Fecha ----
              TextField(
                controller: dateController,
                keyboardType: TextInputType.number,
                maxLength: 5,
                decoration: const InputDecoration(
                  labelText: "Fecha (MM/YY)",
                  prefixIcon: Icon(Icons.date_range),
                ),
                onChanged: (value) {
                  String numbers = value.replaceAll("/", "");
                  String formatted = "";

                  for (int i = 0; i < numbers.length; i++) {
                    if (i == 2) formatted += "/";
                    formatted += numbers[i];
                  }

                  dateController.value = TextEditingValue(
                    text: formatted,
                    selection:
                        TextSelection.collapsed(offset: formatted.length),
                  );
                },
              ),

              // ---- CVV ----
              TextField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                maxLength: 3,
                decoration: const InputDecoration(
                  labelText: "CVV",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

              SizedBox(height: 3.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmPayment,
                  child:
                      Text("Confirmar pago", style: TextStyle(fontSize: 12.sp)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ----------------------------------------------------
  void _confirmPayment() {
    Navigator.pop(context);

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Pago",
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeOutBack.transform(animation.value) - 0.0;

        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: animation.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ícono animado
                    AnimatedScale(
                      scale: animation.value,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutBack,
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      "Pago completado",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      "Tu compra se procesó exitosamente.",
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        setState(() {
                          cartItems.clear();
                          cardController.clear();
                          dateController.clear();
                          cvvController.clear();
                        });
                      },
                      child: const Text("Aceptar"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void eliminar(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void pagar() {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tu carrito está vacío"),
        ),
      );
      return;
    }

    /// Limpia carrito
    setState(() {
      cartItems.clear();
    });

    /// Muestra mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Pago completado con éxito 🎉",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    HapticFeedback.lightImpact();

    if (index == _currentBottomNavIndex) return;

    setState(() => _currentBottomNavIndex = index);

    // Navigate to corresponding screens
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/product-catalog');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/qr-scanner');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/user-profile');
        break;
    }
  }

  int _currentBottomNavIndex = 2;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
      ),
      appBar: AppBar(
        title: const Text("Mi Carrito"),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Text(
                      "Tu carrito está vacío.",
                      style: theme.textTheme.titleMedium,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (_, index) {
                      final item = cartItems[index];
                      return _CartItemCard(
                        name: item["name"],
                        price: item["price"],
                        quantity: item["quantity"],
                        image: item["image"],
                        onAdd: () => incrementar(index),
                        onRemove: () => disminuir(index),
                        onDelete: () => eliminar(index),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: cartItems.length,
                  ),
          ),

          /// FOOTER DE PAGO
          _CheckoutSection(
            total: total,
            onPay: _openPaymentSheet,
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final String name;
  final double price;
  final int quantity;
  final String image;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  const _CartItemCard({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              image,
              width: 85,
              height: 85,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "S/ ${price.toStringAsFixed(2)}",
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onPressed: onRemove,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "$quantity",
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onPressed: onAdd,
                    ),
                  ],
                )
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
            color: theme.colorScheme.error,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Ink(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }
}

class _CheckoutSection extends StatelessWidget {
  final double total;
  final VoidCallback onPay;

  const _CheckoutSection({
    required this.total,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total:",
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "S/ ${total.toStringAsFixed(2)}",
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: onPay,
                child: const Text(
                  "Pagar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------- BottomSheet de Pago -------------
class _PaymentBottomSheet extends StatefulWidget {
  final double total;
  final VoidCallback onPaymentSuccess;

  const _PaymentBottomSheet({
    required this.total,
    required this.onPaymentSuccess,
  });

  @override
  State<_PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<_PaymentBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cardNumber = TextEditingController();
  final TextEditingController cardName = TextEditingController();
  final TextEditingController expDate = TextEditingController();
  final TextEditingController cvv = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.35,
      maxChildSize: 0.85,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Pagar con tarjeta",
                    style: theme.textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _input("Número de tarjeta", cardNumber,
                      keyboard: TextInputType.number),
                  const SizedBox(height: 14),
                  _input("Nombre del titular", cardName),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _input("MM/AA", expDate,
                            keyboard: TextInputType.datetime),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child:
                            _input("CVV", cvv, keyboard: TextInputType.number),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onPaymentSuccess();
                        }
                      },
                      child: Text(
                        "Pagar S/ ${widget.total.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: (v) => v!.isEmpty ? "Completa este campo" : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
