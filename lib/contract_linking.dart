import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  // Sur Android Emulator, localhost est 10.0.2.2.
  final String _rpcUrl = "http://10.0.2.2:7545";
  final String _wsUrl = "ws://10.0.2.2:7545/";
  
  // COPIEZ VOTRE CLÉ PRIVÉE DEPUIS GANACHE ICI
  final String _privateKey = "VOTRE_CLE_PRIVEE_GANACHE";

  late Web3Client _client;
  bool isLoading = true;

  late String _abiCode;
  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;
  late ContractFunction _yourName;
  late ContractFunction _setName;

  String deployedName = "";

  ContractLinking() {
    initialSetup();
  }

  initialSetup() async {
    // Établir la connexion Web3
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    // Lire le fichier JSON généré par Truffle
    String abiStringFile = await rootBundle.loadString("src/artifacts/HelloWorld.json");
    var jsonAbi = jsonDecode(abiStringFile);
    
    _abiCode = jsonEncode(jsonAbi["abi"]);
    // Récupérer l'adresse du contrat (Network ID 5777 est souvent utilisé par Ganache GUI)
    _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "HelloWorld"), _contractAddress);

    _yourName = _contract.function("yourName");
    _setName = _contract.function("setName");
    
    await getName();
  }

  getName() async {
    var currentName = await _client.call(
        contract: _contract, function: _yourName, params: []);
    deployedName = currentName[0];
    isLoading = false;
    notifyListeners();
  }

  setName(String nameToSet) async {
    isLoading = true;
    notifyListeners();
    
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _setName,
        parameters: [nameToSet],
      ),
    );
    
    await getName();
  }
}
