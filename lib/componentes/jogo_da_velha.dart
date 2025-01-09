import 'dart:async';
import 'package:flutter/material.dart';

class JogoDaVelha extends StatefulWidget {
  const JogoDaVelha({Key? key}) : super(key: key);

  @override
  State<JogoDaVelha> createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  List<String> _board = List.filled(9, ''); // Tabuleiro
  String _currentPlayer = 'X'; // Jogador atual
  String _winner = ''; // Vencedor
  bool _isGameOver = false; // Status do jogo
  bool _isVsComputer = false; // Jogo com computador ou humano

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _currentPlayer = 'X';
      _winner = '';
      _isGameOver = false;
    });
  }

  void _handleTap(int index) {
    if (_board[index] != '' || _isGameOver) return;

    setState(() {
      _board[index] = _currentPlayer;
      _checkWinner();
      if (!_isGameOver) {
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
      }
    });

    // Se for contra o computador, o computador faz a jogada após o humano
    if (_isVsComputer && !_isGameOver && _currentPlayer == 'O') {
      Future.delayed(const Duration(seconds: 1), _computerMove);
    }
  }

  void _computerMove() {
    // Computador escolhe a próxima posição disponível (jogo simples)
    int index = _board.indexOf('');
    if (index != -1) {
      setState(() {
        _board[index] = 'O';
        _checkWinner();
        if (!_isGameOver) {
          _currentPlayer = 'X'; // Volta para o jogador
        }
      });
    }
  }

  void _checkWinner() {
    const List<List<int>> winPatterns = [
      [0, 1, 2], // Linhas
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6], // Colunas
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8], // Diagonais
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (_board[pattern[0]] == _board[pattern[1]] &&
          _board[pattern[1]] == _board[pattern[2]] &&
          _board[pattern[0]] != '') {
        setState(() {
          _winner = _board[pattern[0]];
          _isGameOver = true;
        });
        return;
      }
    }

    if (!_board.contains('')) {
      setState(() {
        _winner = 'Empate';
        _isGameOver = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isGameOver)
            Text(
              _winner == 'Empate'
                  ? 'O jogo terminou em empate!'
                  : 'O vencedor é: $_winner!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 20),
          _buildGameModeButton(), // Botão para escolher entre Humano ou Computador
          const SizedBox(height: 20),
          _buildBoard(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            child: const Text('Reiniciar Jogo'),
          ),
        ],
      ),
    );
  }

  // Método para garantir que o tabuleiro tenha um tamanho fixo
  Widget _buildBoard() {
    return Center(
      child: Container(
        width: 300, // Largura fixa do tabuleiro
        height: 300, // Altura fixa do tabuleiro
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 8,
            ),
          ],
        ),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3x3
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _handleTap(index),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  _board[index],
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Botão para selecionar o modo de jogo
  Widget _buildGameModeButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isVsComputer = !_isVsComputer; // Alterna entre Humano e Computador
          _resetGame(); // Reinicia o jogo ao mudar o modo
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
      ),
      child: Text(
        _isVsComputer ? 'Computador' : 'Humano',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
