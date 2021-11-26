extern crate rand;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
enum Nationality {
  Dane,
  Brit,
  Swede,
  Norwegian,
  German,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
enum Color {
  Yellow,
  Red,
  White,
  Green,
  Blue,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
enum Animal {
  Horse,
  Cat,
  Bird,
  Fish,
  Dog,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
enum Beverage {
  Water,
  Tea,
  Milk,
  Coffee,
  RootBeer,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
enum Cigar {
  PallMall,
  Prince,
  BlueMaster,
  Dunhill,
  Blends,
}

#[derive(Clone, Copy, Debug)]
struct House {
  nationality: Nationality,
  color: Color,
  animal: Animal,
  beverage: Beverage,
  cigar: Cigar,
}

trait Annealable {
  fn cost(&self) -> f32;
  fn random_neighbor(&self) -> Self;
}

struct SimulatedAnnealer<T> {
  initial: T,
}

impl<T: Annealable + Clone + std::fmt::Debug> SimulatedAnnealer<T> {
  fn run(&mut self) -> (T, usize) {
    let mut current = self.initial.clone();
    let mut current_cost = current.cost();
    let mut temperature = 1.0;
    let mut num_iterations = 0;

    while current_cost > 0.0 {
      let neighbor = current.random_neighbor();
      let neighbor_cost = neighbor.cost();
      let cost_delta = neighbor_cost - current_cost;

      if cost_delta <= 0.0 ||
         rand::random::<f32>() < (-cost_delta / temperature).exp() {
        current = neighbor;
        current_cost = neighbor_cost;
      }

      num_iterations += 1;

      if num_iterations % 500 == 0 && temperature > 0.1 {
        println!("{}: {} {}", num_iterations, current_cost, temperature);
        temperature -= 0.1;
      }
    }

    (current, num_iterations)
  }
}

#[derive(Clone, Debug)]
struct State {
  houses: [House; 5],
}

impl State {
  fn new(v: Vec<House>) -> Self {
    State { houses: [v[0], v[1], v[2], v[3], v[4]] }
  }
}

impl Annealable for State {
  fn cost(&self) -> f32 {
    let mut cost = 15.0;

    for (i, house) in self.houses.iter().enumerate() {
      cost -=
        [house.nationality == Nationality::Brit &&
         house.color == Color::Red,
         house.nationality == Nationality::Swede &&
         house.animal == Animal::Dog,
         house.nationality == Nationality::Dane &&
         house.beverage == Beverage::Tea,
         i < 4 && house.color == Color::Green &&
         self.houses[i + 1].color == Color::White,
         house.color == Color::Green && house.beverage == Beverage::Coffee,
         house.cigar == Cigar::PallMall && house.animal == Animal::Bird,
         house.color == Color::Yellow && house.cigar == Cigar::Dunhill,
         i == 2 && house.beverage == Beverage::Milk,
         i == 0 && house.nationality == Nationality::Norwegian,
         house.cigar == Cigar::Blends &&
         ((i > 0 && self.houses[i - 1].animal == Animal::Cat) ||
          (i < 4 && self.houses[i + 1].animal == Animal::Cat)),
         house.animal == Animal::Horse &&
         ((i > 0 && self.houses[i - 1].cigar == Cigar::Dunhill) ||
          (i < 4) && self.houses[i + 1].cigar == Cigar::Dunhill),
         house.cigar == Cigar::BlueMaster &&
         house.beverage == Beverage::RootBeer,
         house.nationality == Nationality::German &&
         house.cigar == Cigar::Prince,
         house.nationality == Nationality::Norwegian &&
         ((i > 0 && self.houses[i - 1].color == Color::Blue) ||
          (i < 4) && self.houses[i + 1].color == Color::Blue),
         house.cigar == Cigar::Blends &&
         ((i > 0 && self.houses[i - 1].beverage == Beverage::Water) ||
          (i < 4) && self.houses[i + 1].beverage == Beverage::Water)]
          .iter()
          .filter(|&&x| x)
          .count() as f32;
    }

    cost
  }

  fn random_neighbor(&self) -> Self {
    let mut rng = rand::thread_rng();

    let mut neighbor = self.clone();

    let ab = rand::sample(&mut rng, 0..5, 2);
    let mut a = neighbor.houses[ab[0]];
    let mut b = neighbor.houses[ab[1]];

    match rand::sample(&mut rng, 0..5, 1)[0] {
      0 => std::mem::swap(&mut a.nationality, &mut b.nationality),
      1 => std::mem::swap(&mut a.color, &mut b.color),
      2 => std::mem::swap(&mut a.animal, &mut b.animal),
      3 => std::mem::swap(&mut a.beverage, &mut b.beverage),
      4 => std::mem::swap(&mut a.cigar, &mut b.cigar),
      _ => unreachable!(),
    }

    neighbor.houses[ab[0]] = a;
    neighbor.houses[ab[1]] = b;

    neighbor
  }
}

fn main() {
  let nationalities = vec![Nationality::Dane,
                           Nationality::Brit,
                           Nationality::Swede,
                           Nationality::Norwegian,
                           Nationality::German];
  let colors =
    vec![Color::Yellow, Color::Red, Color::White, Color::Green, Color::Blue];
  let animals =
    vec![Animal::Horse, Animal::Cat, Animal::Bird, Animal::Fish, Animal::Dog];
  let beverages = vec![Beverage::Water,
                       Beverage::Tea,
                       Beverage::Milk,
                       Beverage::Coffee,
                       Beverage::RootBeer];
  let cigars = vec![Cigar::PallMall,
                    Cigar::Prince,
                    Cigar::BlueMaster,
                    Cigar::Dunhill,
                    Cigar::Blends];
  let houses = nationalities.iter()
    .zip(colors.iter())
    .zip(animals.iter())
    .zip(beverages.iter())
    .zip(cigars.iter())
    .map(|((((nationality, color), animal), beverage), cigar)| {
      House {
        nationality: nationality.to_owned(),
        color: color.to_owned(),
        animal: animal.to_owned(),
        beverage: beverage.to_owned(),
        cigar: cigar.to_owned(),
      }
    })
    .collect::<Vec<_>>();
  let state = State::new(houses);

  let mut sa = SimulatedAnnealer { initial: state };
  let (solution, iterations) = sa.run();

  for house in &solution.houses {
    println!("{:?}", house);
  }
  println!("Number of iterations: {}", iterations);
}
