import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: CVScreen()),
  );
}

class CVScreen extends StatelessWidget {
  const CVScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            width: 220,
            color: Colors.amber[700],
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=5',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Contact',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Улаанбаатар хот, Сүхбаатар дүүрэг\n11-р хороо , Денвер\n+976-99119999\nmeirbanbilim@gmail.com',
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Skills',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  _buildBoxItem('HTML & CSS'),
                  _buildBoxItem('Python'),
                  _buildBoxItem('Cybersecurity'),
                  _buildBoxItem('Raspberry Pi'),

                  const SizedBox(height: 20),
                  const Text(
                    'Languages',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  _buildBoxItem('English'),
                  _buildBoxItem('Mongolian'),
                  _buildBoxItem('Kazakh'),
                  _buildBoxItem('Turkish'),
                  _buildBoxItem('Russian'),

                  const SizedBox(height: 20),
                  const Text(
                    'Hobbies',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Icon(Icons.sports_basketball),
                  const Icon(Icons.code),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Meirban Bilim',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Software Engineer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle('About Me'),
                  const Text(
                    'Төрсөн он/: 2004/07/30\n\nБи програм хангамжийн шийдлүүдийг боловсруулах, турших, ашиглах чиглэлээр 3 жилийн туршлагатай, хүсэл эрмэлзэлтэй инженер хүн юм. ReactJS , NextJS болон JavaScript-ийн мэдлэгтэй. HTML/CSS-ийн ойлголттой. Програмчлалын тал нутгийн салхитай холбож, шинэ технологи хөгжүүлэхийг зорьдог билээ.',
                  ),

                  const SizedBox(height: 20),
                  _buildSectionTitle('Work Experience'),
                  _buildEntry('Programmist', '2024–2026'),
                  _buildEntry('Software Engineer', '2028–2030'),
                  _buildEntry('Graphic Designer', '2030–2031'),

                  const SizedBox(height: 20),
                  _buildSectionTitle('Education'),
                  _buildEntry('National University of Mongolia', '2022–2026'),
                  _buildEntry('Tsinghua University / Master', '2026–2028'),

                  const SizedBox(height: 20),
                  _buildSectionTitle('Skills & Expertise'),
                  _buildSkillBar('Programming', 0.95),
                  _buildSkillBar('Data Structures & Algorithms', 0.9),
                  _buildSkillBar('DevOps & CI/CD', 0.85),
                  _buildSkillBar('Cloud & Server Management', 0.8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildBoxItem(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.orange[300],
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEntry(String title, String years) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        '$title  ($years)',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSkillBar(String skill, double level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(skill, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: level,
          backgroundColor: Colors.grey[300],
          color: Colors.redAccent,
          minHeight: 8,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
