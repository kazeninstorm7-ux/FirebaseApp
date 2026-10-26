
import 'package:flutter_test/flutter_test.dart';

Future<int> process() async {
  await Future.delayed(Duration(seconds: 5));
  return 0;
}

Map<String, List<double>> alunos = {
  'Maria': [8.0, 9.0],
  'Bruna': [7.0, 7.0],
  'Carla': [10.0, 9.0],
};

Future<List<double>?> search(String key) async {
  return Future.delayed(Duration(seconds: 2), () {
    if (alunos.containsKey(key)) {
      return alunos[key]!;
    }
    throw ArgumentError('Aluno não encontrado.');
  });
}

Stream<int> count() async* {
  for (int i = 1; i <= 3; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

Stream<double> media(List<String> nomes) async* {
  for (String nome in nomes) {
    try {
      List<double>? notas = await search(nome);

      if (notas != null) {
        double soma = 0;

        for (double nota in notas) {
          soma += nota;
        }

        yield soma / notas.length;
      }
    } on ArgumentError {
      // Continua para o próximo aluno.
    }
  }
}

void main() {
  group('Testes de programação assíncrona', () {
    late Future<int> result;

    setUp(() => result = process());

    test('Aguardando...', () {
      expect(result, isNotNull);
    });

    test('Testando o resultado', () async {
      int num = await result;
      expect(num, 0);
    });

    test('Testando busca sem erros em Future', () async {
      List<double>? notas = await search('Maria');
      expect(notas, [8.0, 9.0]);
    });

    test('Testando busca com erros em Future', () async {
      await expectLater(
        search('Paula'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Testando contagem em Stream', () async {
      await expectLater(
        count(),
        emitsInOrder([1, 2, 3, emitsDone]),
      );
    });

    test('Testando media em Stream', () async {
      await expectLater(
        media(['Maria', 'Paula', 'Bruna']),
        emitsInOrder([8.5, 7.0, emitsDone]),
      );
    });
  });
}
