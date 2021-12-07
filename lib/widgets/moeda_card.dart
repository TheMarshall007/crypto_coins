import 'package:crypto_coins/configs/app_settings.dart';
import 'package:crypto_coins/models/moeda.dart';
import 'package:crypto_coins/pages/moedas_detalhes_page.dart';
import 'package:crypto_coins/repositories/favoritas_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedaCard extends StatefulWidget {
  Moeda moeda;

  MoedaCard({Key? key, required this.moeda}) : super(key: key);

  @override
  _MoedaCardState createState() => _MoedaCardState();
}

class _MoedaCardState extends State<MoedaCard> {

  late NumberFormat real ;

  static Map<String, Color> precoColor = <String, Color>{
    'up': Colors.teal,
    'down': Colors.indigo,
  };

  abrirDetalhes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MoedasDetalhesPage(moeda: widget.moeda),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  final loc = context.read<AppSettings>().locale;
  real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
    return Card(
      margin: EdgeInsets.only(top: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => abrirDetalhes(),
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
          child: Row(
            children: [
              Image.asset(
                widget.moeda.icone,
                width: 40,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.moeda.nome,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.moeda.sigla,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: precoColor['down']!.withOpacity(0.05),
                  border: Border.all(
                    color: precoColor['down']!.withOpacity(0.4),
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  real.format(widget.moeda.preco),
                  style: TextStyle(
                    fontSize: 16,
                    color: precoColor['down'],
                    letterSpacing: -1,
                  ),
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: ListTile(
                      title: Text('Remover das Favoritas'),
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<FavoritasRepository>(context, listen: false)
                            .remove(widget.moeda);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
