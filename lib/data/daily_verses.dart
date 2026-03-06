const List<String> versesOfTheMonth = [
  "GEN.1.1",    // Dia 1: "No princípio, criou Deus os céus e a terra."
  "JOS.1.9",    // Dia 2: "Não to mandei eu? Esforça-te e tem bom ânimo..."
  "PSA.23.1",   // Dia 3: "O Senhor é o meu pastor; nada me faltará."
  "PSA.119.105",// Dia 4: "Lâmpada para os meus pés é tua palavra..."
  "PRO.3.5",    // Dia 5: "Confia no Senhor de todo o teu coração..."
  "PRO.4.23",   // Dia 6: "Sobre tudo o que se deve guardar, guarda o teu coração..."
  "ISA.40.31",  // Dia 7: "Mas os que esperam no Senhor renovarão as suas forças..."
  "ISA.41.10",  // Dia 8: "Não temas, porque eu sou contigo..."
  "JER.29.11",  // Dia 9: "Porque eu bem sei os pensamentos que penso de vós..."
  "MAT.6.33",   // Dia 10: "Mas, buscai primeiro o reino de Deus, e a sua justiça..."
  "MAT.11.28",  // Dia 11: "Vinde a mim, todos os que estais cansados..."
  "JHN.3.16",   // Dia 12: "Porque Deus amou o mundo de tal maneira..."
  "JHN.14.6",   // Dia 13: "Disse-lhe Jesus: Eu sou o caminho, e a verdade, e a vida..."
  "ROM.8.28",   // Dia 14: "E sabemos que todas as coisas contribuem juntamente para o bem..."
  "ROM.12.2",   // Dia 15: "E não vos conformeis com este mundo..."
  "1CO.13.4",   // Dia 16: "O amor é sofredor, é benigno; o amor não é invejoso..."
  "2CO.5.17",   // Dia 17: "Assim que, se alguém está em Cristo, nova criatura é..."
  "2CO.12.9",   // Dia 18: "A minha graça te basta, porque o meu poder se aperfeiçoa na fraqueza."
  "GAL.5.22",   // Dia 19: "Mas o fruto do Espírito é: amor, gozo, paz..."
  "EPH.2.8",    // Dia 20: "Porque pela graça sois salvos, por meio da fé..."
  "EPH.6.11",   // Dia 21: "Revesti-vos de toda a armadura de Deus..."
  "PHP.4.6",    // Dia 22: "Não estejais inquietos por coisa alguma..."
  "PHP.4.13",   // Dia 23: "Posso todas as coisas naquele que me fortalece."
  "COL.3.14",   // Dia 24: "E, sobre tudo isto, revesti-vos de amor..."
  "1TH.5.16",   // Dia 25: "Regozijai-vos sempre."
  "2TI.1.7",    // Dia 26: "Porque Deus não nos deu o espírito de temor, mas de fortaleza..."
  "HEB.4.12",   // Dia 27: "Porque a palavra de Deus é viva e eficaz..."
  "HEB.11.1",   // Dia 28: "Ora, a fé é o firme fundamento das coisas que se esperam..."
  "JAS.1.5",    // Dia 29: "E, se algum de vós tem falta de sabedoria, peça-a a Deus..."
  "1PE.5.7",    // Dia 30: "Lançando sobre ele toda a vossa ansiedade..."
  "REV.21.4",   // Dia 31: "E Deus limpará de seus olhos toda lágrima..."
];

String getVerseOfTheDay() {
  int today = DateTime.now().day;
  return versesOfTheMonth[today - 1];
}