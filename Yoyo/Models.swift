import Foundation

/// How much detail a lesson explanation should show.
enum LessonLevel: Int, CaseIterable, Identifiable {
    case simple = 0
    case standard = 1
    case exam = 2

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .simple: return "Simple"
        case .standard: return "Standard"
        case .exam: return "Exam"
        }
    }

    var icon: String {
        switch self {
        case .simple: return "leaf.fill"
        case .standard: return "book.fill"
        case .exam: return "graduationcap.fill"
        }
    }
}

struct BiologyQuestion: Identifiable, Hashable {
    let id: Int
    let stem: String
    let options: [String]
    let correctIndex: Int
    let topic: String
    let lessonTitle: String
    /// Exam-level explanation (concise, O-Level style).
    let lessonBody: String
    /// Super-simple explanation for younger readers (grade 6–7).
    let simpleBody: String
    /// Middle-detail explanation.
    let standardBody: String
    let tip: String

    /// The explanation body for a chosen detail level, falling back to the
    /// exam text if a simpler level has not been written.
    func body(for level: LessonLevel) -> String {
        switch level {
        case .simple: return simpleBody.isEmpty ? lessonBody : simpleBody
        case .standard: return standardBody.isEmpty ? lessonBody : standardBody
        case .exam: return lessonBody
        }
    }
}

/// A single exam paper made up of multiple-choice questions.
struct Paper: Identifiable, Hashable {
    let id: Int
    let subject: String
    let code: String
    let session: String
    let paperTitle: String
    let duration: String
    let marks: String
    let questions: [BiologyQuestion]
}

struct DemoPaper {
    static let papers: [Paper] = [
        biology1, biology2, biology3,
        chemistry1, chemistry2,
        maths1, maths2
    ]

    // MARK: Biology · Paper 1 (questions 1–12)
    static let biology1 = Paper(
        id: 1, subject: "Biology", code: "5090/11", session: "May/June 2026",
        paperTitle: "Paper 1 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 1, stem: "Which feature is found in a plant cell but not in an animal cell?", options: ["Cell membrane", "Cytoplasm", "Cellulose cell wall", "Ribosome"], correctIndex: 2, topic: "Cell structure", lessonTitle: "Plant vs animal cells", lessonBody: "Both plant and animal cells have a cell membrane, cytoplasm and ribosomes. Plant cells also have a cellulose cell wall. Many plant cells contain chloroplasts and a large permanent vacuole too.", simpleBody: "Plant cells have an extra strong wall around them. This wall is made of cellulose, which is a tough material that keeps the cell's shape. Animal cells do not have this wall.", standardBody: "Plant and animal cells both have a membrane, cytoplasm and ribosomes. Only plant cells add a cellulose cell wall (and often chloroplasts and a big vacuole) for support.", tip: "Look for the structure that gives plant cells extra support."),
            .init(id: 2, stem: "What is the main function of red blood cells?", options: ["Defence against pathogens", "Transport of oxygen", "Blood clotting", "Production of hormones"], correctIndex: 1, topic: "Transport in humans", lessonTitle: "Red blood cells", lessonBody: "Red blood cells carry oxygen from the lungs to respiring tissues. They contain haemoglobin, which binds reversibly with oxygen. Their biconcave shape increases surface area for gas exchange.", simpleBody: "Red blood cells carry oxygen around your body. They pick up oxygen in the lungs and drop it off where it is needed. A red chemical called haemoglobin grabs the oxygen.", standardBody: "Red blood cells carry oxygen from the lungs to the rest of the body. They are full of haemoglobin, which joins with oxygen, and their flat dented shape helps them absorb it quickly.", tip: "Think haemoglobin."),
            .init(id: 3, stem: "Which process moves water through a partially permeable membrane from a dilute solution to a more concentrated solution?", options: ["Active transport", "Diffusion", "Osmosis", "Transpiration"], correctIndex: 2, topic: "Movement in and out of cells", lessonTitle: "Osmosis", lessonBody: "Osmosis is the net movement of water molecules from a region of higher water potential to lower water potential through a partially permeable membrane.", simpleBody: "Osmosis is just water moving. Water moves through a thin layer (a membrane) from where there is lots of water to where there is less. 'Partially permeable' means only some things, like water, can pass through.", standardBody: "Osmosis is the movement of water through a partially permeable membrane, from a dilute solution (more water) to a concentrated one (less water).", tip: "Water + partially permeable membrane = osmosis."),
            .init(id: 4, stem: "Which gas is used by green plants during photosynthesis?", options: ["Carbon dioxide", "Nitrogen", "Oxygen", "Water vapour"], correctIndex: 0, topic: "Photosynthesis", lessonTitle: "Raw materials for photosynthesis", lessonBody: "Photosynthesis uses carbon dioxide and water to make glucose, using light energy absorbed by chlorophyll. Oxygen is released as a product.", simpleBody: "Green plants make their own food using sunlight. They take in a gas called carbon dioxide from the air and water from the soil. They give out oxygen, the gas we breathe.", standardBody: "In photosynthesis a plant uses carbon dioxide, water and light energy (caught by green chlorophyll) to make glucose, and releases oxygen.", tip: "Recall the word equation for photosynthesis."),
            .init(id: 5, stem: "Where does most aerobic respiration occur inside a cell?", options: ["Cell wall", "Mitochondrion", "Nucleus", "Vacuole"], correctIndex: 1, topic: "Respiration", lessonTitle: "Mitochondria and energy", lessonBody: "Mitochondria are the main site of aerobic respiration. Cells that need lots of energy, such as muscle cells, often contain many mitochondria.", simpleBody: "Cells get their energy inside tiny parts called mitochondria. Think of them as tiny batteries. Busy cells, like muscle cells, have lots of them.", standardBody: "Most aerobic respiration (releasing energy using oxygen) happens in the mitochondria. Very active cells contain many mitochondria to supply enough energy.", tip: "The 'powerhouse' clue points to mitochondria."),
            .init(id: 6, stem: "Which enzyme digests starch?", options: ["Amylase", "Lipase", "Pepsin", "Trypsin"], correctIndex: 0, topic: "Nutrition", lessonTitle: "Digestive enzymes", lessonBody: "Amylase breaks starch into smaller sugars such as maltose. Lipase breaks down fats, while proteases such as pepsin and trypsin digest proteins.", simpleBody: "Enzymes are tiny helpers that break food into smaller bits. The enzyme called amylase breaks down starch (found in bread and rice) into sugar.", standardBody: "Amylase is the enzyme that digests starch into smaller sugars. Other enzymes have other jobs: lipase breaks down fats and proteases break down proteins.", tip: "Amylase sounds like amylose, a component of starch."),
            .init(id: 7, stem: "What happens to the pupil in bright light?", options: ["It gets larger", "It gets smaller", "It changes colour", "It moves towards the lens"], correctIndex: 1, topic: "Coordination and response", lessonTitle: "The pupil reflex", lessonBody: "In bright light, circular muscles in the iris contract and radial muscles relax, making the pupil smaller. This reduces the amount of light entering the eye and helps protect the retina.", simpleBody: "The pupil is the black hole in your eye that lets light in. In bright light it gets smaller so that too much light does not hurt the back of your eye.", standardBody: "In bright light the pupil gets smaller. Muscles in the coloured iris change its size to control how much light enters and to protect the eye.", tip: "Bright light → less light should enter."),
            .init(id: 8, stem: "Which blood vessel carries blood away from the heart?", options: ["Artery", "Capillary", "Vein", "Venule"], correctIndex: 0, topic: "Circulation", lessonTitle: "Arteries and veins", lessonBody: "Arteries carry blood away from the heart. Veins carry blood towards the heart. Capillaries are tiny exchange vessels connecting the two systems.", simpleBody: "Blood travels in tubes. Arteries are the tubes that carry blood AWAY from the heart. An easy way to remember: Artery = Away.", standardBody: "Arteries carry blood away from the heart, veins carry it back to the heart, and tiny capillaries link them where substances are exchanged.", tip: "Artery = Away."),
            .init(id: 9, stem: "Which condition is required for seed germination?", options: ["Carbon dioxide", "Light in every species", "Water", "Chlorophyll"], correctIndex: 2, topic: "Plant reproduction", lessonTitle: "Germination", lessonBody: "Most seeds need water, oxygen and a suitable temperature to germinate. Light is required by some species, but it is not a universal requirement.", simpleBody: "For a seed to start growing it needs water. Water wakes the seed up. It also needs air and warmth. It does not always need light.", standardBody: "Seeds need water, oxygen and warmth to germinate (start growing). Water is always needed, but light is only needed by some kinds of seed.", tip: "Think about what activates enzymes inside the seed."),
            .init(id: 10, stem: "Which statement about a dominant allele is correct?", options: ["It is always more common", "It is expressed in a heterozygote", "It must be beneficial", "It is only found on the X chromosome"], correctIndex: 1, topic: "Inheritance", lessonTitle: "Dominant and recessive alleles", lessonBody: "A dominant allele is expressed in the phenotype when just one copy is present. A recessive allele is usually expressed only when two copies are present.", simpleBody: "You get two copies of each gene, one from each parent. A 'dominant' one is the boss — it shows up even if you have just one copy of it.", standardBody: "A dominant allele shows its effect even when only one copy is present. A recessive allele usually needs two copies to show.", tip: "Focus on expression, not frequency or usefulness."),
            .init(id: 11, stem: "Which organism is a decomposer?", options: ["Grass", "Hawk", "Mushroom", "Rabbit"], correctIndex: 2, topic: "Ecology", lessonTitle: "Decomposers", lessonBody: "Many fungi and bacteria act as decomposers. They feed on dead organic matter and release mineral ions back into the environment.", simpleBody: "Decomposers are living things that break down dead plants and animals. A mushroom (a type of fungus) does this. It is like nature's recycling.", standardBody: "Decomposers such as fungi (mushrooms) and bacteria feed on dead material and return useful minerals to the soil.", tip: "Look for a fungus or bacterium."),
            .init(id: 12, stem: "Which change would usually increase the rate of an enzyme-controlled reaction up to its optimum?", options: ["Lowering substrate concentration", "Increasing temperature", "Removing the enzyme", "Making the solution extremely acidic"], correctIndex: 1, topic: "Enzymes", lessonTitle: "Temperature and enzymes", lessonBody: "Increasing temperature gives molecules more kinetic energy, so enzyme and substrate particles collide more often. Above the optimum, the enzyme's active site begins to lose its shape and activity falls.", simpleBody: "Enzymes work faster when it gets warmer, up to a best temperature. That is because warmth makes the tiny particles move and bump into each other more.", standardBody: "Warming things up (up to the enzyme's best temperature) speeds up the reaction, because particles move faster and collide more often.", tip: "The key phrase is 'up to its optimum'.")
        ]
    )

    // MARK: Biology · Paper 2 (questions 101–108)
    static let biology2 = Paper(
        id: 2, subject: "Biology", code: "5090/12", session: "Oct/Nov 2025",
        paperTitle: "Paper 2 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 101, stem: "Enzymes are biological catalysts. What type of molecule are they made from?", options: ["Proteins", "Lipids", "Carbohydrates", "Nucleic acids"], correctIndex: 0, topic: "Enzymes", lessonTitle: "What enzymes are made of", lessonBody: "Enzymes are proteins that speed up reactions without being used up. Their precise three-dimensional shape, especially the active site, is what makes each enzyme specific to its substrate.", simpleBody: "Enzymes are made of protein. They speed up reactions in the body but are not used up, so they can be used again and again.", standardBody: "Enzymes are proteins. Their special shape lets them speed up a particular reaction without being used up themselves.", tip: "Enzyme names often end in '-ase', but the material is protein."),
            .init(id: 102, stem: "Which feature of the alveoli increases the rate of gas exchange?", options: ["Thick muscular walls", "A large surface area", "A dry lining", "Few blood capillaries"], correctIndex: 1, topic: "Gas exchange", lessonTitle: "Alveoli and gas exchange", lessonBody: "Alveoli have a very large surface area, thin walls one cell thick, a moist lining and a rich blood supply. Together these give a short diffusion distance and a steep concentration gradient.", simpleBody: "Alveoli are tiny air bags in your lungs. There are millions of them, so together they give a huge surface for gases to move across quickly.", standardBody: "A large surface area speeds up gas exchange in the alveoli. Their thin, moist walls and good blood supply also help gases move across fast.", tip: "Big surface area + thin walls = fast diffusion."),
            .init(id: 103, stem: "Which organ removes urea from the blood?", options: ["Liver", "Kidney", "Lungs", "Pancreas"], correctIndex: 1, topic: "Excretion", lessonTitle: "Excreting urea", lessonBody: "Urea is made in the liver from excess amino acids. It is then carried in the blood to the kidneys, which filter it out and remove it in urine.", simpleBody: "The kidneys clean your blood. They take out a waste chemical called urea and remove it from the body in your urine (wee).", standardBody: "The kidneys filter urea (a waste made in the liver) out of the blood and remove it in urine.", tip: "Liver makes urea; kidney removes it."),
            .init(id: 104, stem: "Water moves up the xylem of a plant mainly because of which process?", options: ["Translocation", "Transpiration pull", "Active transport", "Osmosis in the phloem"], correctIndex: 1, topic: "Transport in plants", lessonTitle: "The transpiration stream", lessonBody: "Water evaporates from the leaves in transpiration. This creates a pull that draws a continuous column of water up through the xylem from the roots.", simpleBody: "Plants pull water up from their roots to their leaves. As water dries off the leaves, it pulls more water up the plant, a bit like sucking a straw.", standardBody: "Water moves up the xylem because water evaporating from the leaves (transpiration) creates a pull that drags water up from the roots.", tip: "Evaporation at the top pulls water up."),
            .init(id: 105, stem: "Which hormone lowers blood glucose concentration?", options: ["Adrenaline", "Insulin", "Glucagon", "Testosterone"], correctIndex: 1, topic: "Hormones", lessonTitle: "Controlling blood glucose", lessonBody: "Insulin is released by the pancreas when blood glucose is high. It causes the liver to convert glucose into glycogen for storage, lowering the concentration in the blood.", simpleBody: "Insulin is a chemical messenger. When there is too much sugar in your blood, insulin tells the body to store it away, so the sugar level goes down.", standardBody: "Insulin, made by the pancreas, lowers blood sugar by telling the liver to store glucose as glycogen.", tip: "Insulin puts glucose 'in' to storage."),
            .init(id: 106, stem: "Which cells produce antibodies to fight infection?", options: ["Red blood cells", "Lymphocytes", "Platelets", "Nerve cells"], correctIndex: 1, topic: "Disease and immunity", lessonTitle: "Antibodies and lymphocytes", lessonBody: "Lymphocytes are white blood cells that produce antibodies. Antibodies lock onto antigens on pathogens, helping to destroy them and providing future immunity.", simpleBody: "Some white blood cells, called lymphocytes, make tiny weapons called antibodies. Antibodies stick to germs and help destroy them.", standardBody: "Lymphocytes are white blood cells that make antibodies. Antibodies lock onto germs (pathogens) to help destroy them.", tip: "Lymphocytes make the 'locks' for antigens."),
            .init(id: 107, stem: "Which best describes natural selection?", options: ["Organisms choose to change", "The best-adapted organisms survive and reproduce", "All offspring are identical", "Characteristics are always inherited equally"], correctIndex: 1, topic: "Variation and selection", lessonTitle: "Natural selection", lessonBody: "Individuals vary. Those with characteristics best suited to their environment are more likely to survive and reproduce, passing on the useful alleles to the next generation.", simpleBody: "Living things are all a bit different. The ones that fit their surroundings best are more likely to survive and have babies, passing on their helpful features.", standardBody: "In natural selection, the individuals best suited to their environment are most likely to survive, reproduce and pass on their useful genes.", tip: "Think 'survival of the best adapted'."),
            .init(id: 108, stem: "Burning fossil fuels adds which gas that contributes most to the enhanced greenhouse effect?", options: ["Oxygen", "Carbon dioxide", "Nitrogen", "Argon"], correctIndex: 1, topic: "Human impact", lessonTitle: "The greenhouse effect", lessonBody: "Burning fossil fuels releases carbon dioxide, a greenhouse gas that traps heat in the atmosphere. Rising levels are linked to global warming and climate change.", simpleBody: "When we burn fuels like coal, oil and petrol, we make a gas called carbon dioxide. This gas traps heat and warms up the Earth.", standardBody: "Burning fossil fuels adds carbon dioxide to the air. It is a greenhouse gas that traps heat, causing global warming.", tip: "Fossil fuels + carbon = carbon dioxide.")
        ]
    )

    // MARK: Biology · Paper 3 (questions 301–310)
    static let biology3 = Paper(
        id: 4, subject: "Biology", code: "5090/13", session: "May/June 2025",
        paperTitle: "Paper 1 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 301, stem: "Which structure controls what enters and leaves a cell?", options: ["Cell wall", "Cell membrane", "Nucleus", "Vacuole"], correctIndex: 1, topic: "Cell structure", lessonTitle: "The cell membrane", lessonBody: "The cell membrane is partially permeable and controls the movement of substances into and out of the cell. The cell wall in plants is fully permeable and gives support, not control.", simpleBody: "The cell membrane is like a skin around the cell. It decides what can go in and out. 'Partially permeable' means only some things can pass through.", standardBody: "The cell membrane controls what enters and leaves the cell because it is partially permeable. The cell wall only gives support.", tip: "Control of entry/exit = membrane, not wall."),
            .init(id: 302, stem: "The movement of glucose into a cell against a concentration gradient uses…", options: ["Diffusion", "Osmosis", "Active transport", "Filtration"], correctIndex: 2, topic: "Movement in and out of cells", lessonTitle: "Active transport", lessonBody: "Active transport moves substances from a low to a high concentration, against the gradient. It requires energy from respiration, unlike diffusion and osmosis which are passive.", simpleBody: "Sometimes a cell needs to pull something in even when there is already lots inside. This uphill move is called active transport, and it costs the cell energy.", standardBody: "Active transport moves a substance against its concentration gradient (from low to high), so it needs energy from respiration.", tip: "Against the gradient = energy = active transport."),
            .init(id: 303, stem: "Which food group is the body's main source of energy?", options: ["Proteins", "Carbohydrates", "Vitamins", "Minerals"], correctIndex: 1, topic: "Nutrition", lessonTitle: "Energy from food", lessonBody: "Carbohydrates such as starch and sugars are the body's main energy source. Fats are a more concentrated energy store, while proteins are mainly used for growth and repair.", simpleBody: "Foods like bread, rice and pasta contain carbohydrates. These are the body's main fuel for energy.", standardBody: "Carbohydrates (starches and sugars) are the body's main energy source. Fats store energy and proteins are mainly for growth and repair.", tip: "Carbohydrates are the go-to fuel."),
            .init(id: 304, stem: "Deoxygenated blood is carried from the heart to the lungs by the…", options: ["Aorta", "Pulmonary artery", "Pulmonary vein", "Vena cava"], correctIndex: 1, topic: "Circulation", lessonTitle: "Pulmonary circulation", lessonBody: "The pulmonary artery is unusual: it is an artery that carries deoxygenated blood, taking it from the heart to the lungs. The pulmonary vein returns oxygenated blood to the heart.", simpleBody: "The pulmonary artery carries blood with no oxygen from the heart to the lungs, so it can pick up fresh oxygen. ('Deoxygenated' means the oxygen has been used up.)", standardBody: "The pulmonary artery carries deoxygenated blood from the heart to the lungs. Unusually for an artery, its blood has little oxygen.", tip: "Arteries leave the heart — even the pulmonary artery."),
            .init(id: 305, stem: "Which part of a leaf is the main site of photosynthesis?", options: ["Waxy cuticle", "Palisade mesophyll", "Xylem", "Lower epidermis"], correctIndex: 1, topic: "Photosynthesis", lessonTitle: "Palisade cells", lessonBody: "Palisade mesophyll cells near the top of the leaf are packed with chloroplasts to absorb the most light, making them the main site of photosynthesis.", simpleBody: "Near the top of a leaf are tall cells full of green chloroplasts. They catch the most sunlight, so most food-making (photosynthesis) happens there.", standardBody: "The palisade cells near the top of the leaf are packed with chloroplasts to catch light, so most photosynthesis happens there.", tip: "Most chloroplasts = palisade layer."),
            .init(id: 306, stem: "A reflex action is best described as a response that is…", options: ["Slow and voluntary", "Rapid and automatic", "Always learned", "Controlled by hormones"], correctIndex: 1, topic: "Coordination and response", lessonTitle: "Reflex actions", lessonBody: "A reflex is a fast, automatic response that does not involve conscious thought. It protects the body from harm, for example pulling your hand off a hot object.", simpleBody: "A reflex is something your body does super fast without thinking, like pulling your hand away from something hot. It keeps you safe.", standardBody: "A reflex action is a fast, automatic response you do not have to think about, such as pulling away from something hot.", tip: "Reflex = fast + automatic + protective."),
            .init(id: 307, stem: "Which gas is present in a greater amount in exhaled air than in inhaled air?", options: ["Oxygen", "Nitrogen", "Carbon dioxide", "Argon"], correctIndex: 2, topic: "Gas exchange", lessonTitle: "Inhaled vs exhaled air", lessonBody: "Exhaled air contains more carbon dioxide and water vapour, and less oxygen, than inhaled air. Nitrogen is roughly unchanged.", simpleBody: "The air you breathe out has more carbon dioxide in it than the air you breathe in. Your body makes carbon dioxide as a waste gas.", standardBody: "Breathed-out air has more carbon dioxide (and water vapour) and less oxygen than breathed-in air.", tip: "Respiration produces carbon dioxide."),
            .init(id: 308, stem: "The genetic material of a eukaryotic cell is found mainly in the…", options: ["Cytoplasm", "Nucleus", "Cell membrane", "Ribosomes"], correctIndex: 1, topic: "Inheritance", lessonTitle: "Where DNA is stored", lessonBody: "In animal and plant cells the chromosomes, made of DNA, are contained in the nucleus. The nucleus controls the activities of the cell.", simpleBody: "The nucleus is the control centre of the cell. It holds the instructions (DNA) that tell the cell what to do.", standardBody: "A cell's genetic material (DNA) is stored in the nucleus, which controls the cell's activities.", tip: "Nucleus = the cell's control centre."),
            .init(id: 309, stem: "Scurvy is caused by a lack of which vitamin?", options: ["Vitamin A", "Vitamin C", "Vitamin D", "Vitamin K"], correctIndex: 1, topic: "Nutrition", lessonTitle: "Vitamin deficiencies", lessonBody: "A lack of vitamin C causes scurvy, with symptoms such as bleeding gums. Vitamin D deficiency causes rickets, and vitamin A deficiency can cause night blindness.", simpleBody: "If you do not get enough vitamin C (found in oranges), you can get an illness called scurvy. One sign is bleeding gums.", standardBody: "Not enough vitamin C causes scurvy (for example bleeding gums). Different vitamins prevent different deficiency diseases.", tip: "C for scurvy; D for rickets."),
            .init(id: 310, stem: "In a food chain, the arrows show the direction of…", options: ["Energy flow", "Movement of animals", "Water flow", "Carbon dioxide"], correctIndex: 0, topic: "Ecology", lessonTitle: "Reading a food chain", lessonBody: "Arrows in a food chain point from the organism being eaten to the one eating it, showing the direction that energy (and biomass) flows through the chain.", simpleBody: "In a food chain, the arrows show which way the energy goes. They point from the food to the animal that eats it.", standardBody: "Food-chain arrows point from the thing being eaten to the eater, showing the direction energy flows.", tip: "Arrows follow the energy, from prey to predator.")
        ]
    )

    // MARK: Chemistry · Paper 1 (questions 201–208)
    static let chemistry1 = Paper(
        id: 3, subject: "Chemistry", code: "5070/11", session: "May/June 2026",
        paperTitle: "Paper 1 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 201, stem: "The number of protons in an atom is known as its…", options: ["Mass number", "Atomic number", "Neutron number", "Isotope number"], correctIndex: 1, topic: "Atomic structure", lessonTitle: "Atomic number", lessonBody: "The atomic number is the number of protons in an atom and defines which element it is. The mass number counts protons plus neutrons.", simpleBody: "Every atom has tiny bits called protons in its middle. The number of protons is called the atomic number, and it tells you which element it is.", standardBody: "The atomic number is how many protons an atom has. It decides which element the atom is.", tip: "Protons = atomic number = the element's identity."),
            .init(id: 202, stem: "Which type of bonding holds sodium chloride together?", options: ["Covalent", "Ionic", "Metallic", "Hydrogen"], correctIndex: 1, topic: "Bonding", lessonTitle: "Ionic bonding", lessonBody: "Sodium chloride forms when sodium transfers an electron to chlorine, creating oppositely charged ions. The strong electrostatic attraction between these ions is ionic bonding.", simpleBody: "Salt is held together by ionic bonding. One atom gives an electron to another. This makes them have opposite charges, and opposite charges pull together.", standardBody: "In sodium chloride, sodium gives an electron to chlorine, forming oppositely charged ions. Their strong attraction is called ionic bonding.", tip: "Metal + non-metal usually means ionic."),
            .init(id: 203, stem: "What is the approximate pH of a strong acid?", options: ["Exactly 7", "Below 7", "Above 7", "Exactly 14"], correctIndex: 1, topic: "Acids and bases", lessonTitle: "The pH scale", lessonBody: "Acids have a pH below 7, with strong acids close to 0–1. Neutral solutions are pH 7 and alkalis are above 7.", simpleBody: "The pH scale measures how acidic something is, from 0 to 14. Acids have a low number, below 7. Strong acids are near 0 or 1.", standardBody: "Acids have a pH below 7; the stronger the acid, the closer to 0. Neutral is 7 and alkalis are above 7.", tip: "Acid = below 7; alkali = above 7."),
            .init(id: 204, stem: "How does the reactivity of Group I metals change going down the group?", options: ["It decreases", "It increases", "It stays the same", "It increases then decreases"], correctIndex: 1, topic: "The Periodic Table", lessonTitle: "Group I reactivity", lessonBody: "Going down Group I, the outer electron is further from the nucleus and more easily lost, so the metals become more reactive.", simpleBody: "Group I metals get more reactive as you go down the list. Lower down, the outer electron is further away and easier to lose, so they react more.", standardBody: "Going down Group I, the outer electron is further from the centre and easier to lose, so the metals get more reactive.", tip: "Further from the nucleus = easier to lose the electron."),
            .init(id: 205, stem: "What is the relative formula mass of water, H₂O? (Aᵣ: H = 1, O = 16)", options: ["16", "17", "18", "20"], correctIndex: 2, topic: "Stoichiometry", lessonTitle: "Relative formula mass", lessonBody: "Add the relative atomic masses of every atom: two hydrogens (2 × 1) plus one oxygen (16) gives 18.", simpleBody: "Water is H₂O: two hydrogen atoms and one oxygen atom. Add their masses: 1 + 1 + 16 = 18.", standardBody: "Add up the masses of the atoms in H₂O: two hydrogen (1 each) plus one oxygen (16) makes 18.", tip: "Count every atom, then add the masses."),
            .init(id: 206, stem: "Increasing which factor generally increases the rate of a reaction?", options: ["Lower temperature", "Larger particle size", "Higher concentration", "Removing the catalyst"], correctIndex: 2, topic: "Rates of reaction", lessonTitle: "Speeding up reactions", lessonBody: "Higher concentration means more particles in the same volume, so collisions happen more often and the reaction speeds up. Higher temperature, smaller particles and catalysts also increase rate.", simpleBody: "A reaction goes faster when the liquid is more concentrated (more crowded with particles). More particles means they bump into each other more, so the reaction speeds up.", standardBody: "Higher concentration packs more particles into the same space, so they collide more often and the reaction speeds up.", tip: "More frequent collisions = faster reaction."),
            .init(id: 207, stem: "During electrolysis, positively charged ions move towards the…", options: ["Anode", "Cathode", "Electrolyte", "Battery"], correctIndex: 1, topic: "Electrolysis", lessonTitle: "Electrolysis basics", lessonBody: "Positive ions (cations) are attracted to the negative electrode, the cathode. Negative ions move to the positive electrode, the anode.", simpleBody: "In electrolysis, electricity splits a substance. The positive bits move to the negative side (the cathode), because opposite charges attract.", standardBody: "During electrolysis, positive ions move to the negative electrode (cathode) and negative ions move to the positive electrode (anode).", tip: "Cations (positive) go to the cathode (negative)."),
            .init(id: 208, stem: "What is the general formula for the alkanes?", options: ["CₙH₂ₙ", "CₙH₂ₙ₊₂", "CₙH₂ₙ₋₂", "CₙHₙ"], correctIndex: 1, topic: "Organic chemistry", lessonTitle: "The alkane series", lessonBody: "Alkanes are saturated hydrocarbons with only single bonds. They follow the general formula CₙH₂ₙ₊₂, such as methane CH₄ and ethane C₂H₆.", simpleBody: "Alkanes are molecules made of carbon and hydrogen with only single bonds. Their pattern is CₙH₂ₙ₊₂, like methane (CH₄).", standardBody: "Alkanes are saturated hydrocarbons (only single bonds). They follow the formula CₙH₂ₙ₊₂, for example methane CH₄.", tip: "Alkanes are saturated: CₙH₂ₙ₊₂.")
        ]
    )

    // MARK: Chemistry · Paper 2 (questions 401–410)
    static let chemistry2 = Paper(
        id: 5, subject: "Chemistry", code: "5070/12", session: "Oct/Nov 2025",
        paperTitle: "Paper 1 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 401, stem: "Which sub-atomic particle has a negative charge?", options: ["Proton", "Neutron", "Electron", "Nucleus"], correctIndex: 2, topic: "Atomic structure", lessonTitle: "Charges of particles", lessonBody: "Electrons carry a negative charge, protons a positive charge, and neutrons have no charge. Electrons orbit the nucleus in shells.", simpleBody: "Atoms are made of three parts. The electron is the part with a negative charge. It moves around the outside of the atom.", standardBody: "Electrons have a negative charge and move around the nucleus. Protons are positive and neutrons have no charge.", tip: "Electron = negative."),
            .init(id: 402, stem: "A substance that speeds up a reaction but is left unchanged at the end is a…", options: ["Reactant", "Catalyst", "Product", "Solvent"], correctIndex: 1, topic: "Rates of reaction", lessonTitle: "Catalysts", lessonBody: "A catalyst increases the rate of a reaction by providing an alternative pathway with lower activation energy. It is not used up, so it can be reused.", simpleBody: "A catalyst is something that makes a reaction go faster but does not get used up. So you can use it again and again.", standardBody: "A catalyst speeds up a reaction without being used up, so it can be reused.", tip: "Catalyst helps but is not consumed."),
            .init(id: 403, stem: "What is formed when a metal reacts with oxygen?", options: ["An acid", "A metal oxide", "A salt", "Hydrogen"], correctIndex: 1, topic: "Chemical reactions", lessonTitle: "Metal + oxygen", lessonBody: "Metals react with oxygen to form metal oxides, which are usually basic. For example, magnesium burns in oxygen to form magnesium oxide.", simpleBody: "When a metal joins with oxygen from the air, it makes a metal oxide. For example, magnesium + oxygen makes magnesium oxide.", standardBody: "A metal reacting with oxygen forms a metal oxide, for example magnesium oxide.", tip: "Metal + oxygen → metal oxide."),
            .init(id: 404, stem: "Which is the correct laboratory test for oxygen gas?", options: ["It bleaches damp litmus paper", "It relights a glowing splint", "It pops with a lit splint", "It turns limewater milky"], correctIndex: 1, topic: "Gas tests", lessonTitle: "Testing for oxygen", lessonBody: "Oxygen relights a glowing splint. Hydrogen gives a squeaky pop, carbon dioxide turns limewater milky, and chlorine bleaches damp litmus.", simpleBody: "To test for oxygen, put a glowing wooden stick (a splint) into the gas. If it bursts back into flame, the gas is oxygen.", standardBody: "Oxygen relights a glowing splint. That is the standard test for oxygen gas.", tip: "Glowing splint relights in oxygen."),
            .init(id: 405, stem: "The products of the complete combustion of a hydrocarbon are…", options: ["Carbon monoxide and water", "Carbon dioxide and water", "Carbon and hydrogen", "Hydrogen only"], correctIndex: 1, topic: "Organic chemistry", lessonTitle: "Complete combustion", lessonBody: "When a hydrocarbon burns in plenty of oxygen it undergoes complete combustion, producing carbon dioxide and water. Incomplete combustion produces carbon monoxide or soot.", simpleBody: "When a fuel burns fully in lots of air, it makes two things: carbon dioxide gas and water. This is called complete combustion.", standardBody: "Complete combustion of a hydrocarbon (burning in plenty of oxygen) produces carbon dioxide and water.", tip: "Plenty of oxygen → CO₂ + H₂O."),
            .init(id: 406, stem: "Which technique is used to obtain pure water from salt solution?", options: ["Filtration", "Simple distillation", "Chromatography", "Decanting"], correctIndex: 1, topic: "Separation techniques", lessonTitle: "Distillation", lessonBody: "Simple distillation evaporates the water and then condenses it, leaving the dissolved salt behind. Filtration only separates insoluble solids from liquids.", simpleBody: "To get pure water from salty water, you boil it so the water turns to steam, then cool the steam back to water. The salt is left behind. This is distillation.", standardBody: "Simple distillation boils off the water and cools it back to liquid, leaving the salt behind, giving pure water.", tip: "Distillation separates a dissolved solute from its solvent."),
            .init(id: 407, stem: "In the reactivity series, which of these metals is the most reactive?", options: ["Copper", "Iron", "Potassium", "Gold"], correctIndex: 2, topic: "The Periodic Table", lessonTitle: "Reactivity series", lessonBody: "Potassium is very high in the reactivity series and reacts vigorously, even with cold water. Copper and gold are low and unreactive.", simpleBody: "Some metals react a lot and some barely react. Potassium reacts strongly, even with cold water, so it is the most reactive one here.", standardBody: "Potassium is high in the reactivity series and reacts strongly, while copper and gold are unreactive.", tip: "Group I metals like potassium are very reactive."),
            .init(id: 408, stem: "A halogen atom in Group VII typically reacts by…", options: ["Losing one electron", "Gaining one electron", "Losing two electrons", "Staying unreactive"], correctIndex: 1, topic: "Bonding", lessonTitle: "Halogens gaining electrons", lessonBody: "Halogens have seven outer electrons, so they gain one electron to complete their outer shell, forming a 1– ion (for example a chloride ion, Cl⁻).", simpleBody: "Halogens like chlorine have 7 electrons on their outside and want 8. So they grab one more electron to become full.", standardBody: "Halogens have seven outer electrons, so they gain one to fill their outer shell, forming a 1– ion.", tip: "Seven outer electrons → gain one to reach eight."),
            .init(id: 409, stem: "What colour does universal indicator turn in a strong alkali?", options: ["Red", "Green", "Purple", "Yellow"], correctIndex: 2, topic: "Acids and bases", lessonTitle: "Universal indicator", lessonBody: "Universal indicator turns purple/violet in a strong alkali (high pH), green in a neutral solution, and red in a strong acid (low pH).", simpleBody: "Universal indicator changes colour to show acid or alkali. In a strong alkali it turns purple. In a strong acid it turns red.", standardBody: "In a strong alkali, universal indicator turns purple; green is neutral and red is a strong acid.", tip: "Purple = strongly alkaline."),
            .init(id: 410, stem: "Metallic bonding is best described as…", options: ["Positive ions in a sea of delocalised electrons", "Shared pairs of electrons between two atoms", "The transfer of electrons to a non-metal", "Weak forces between molecules"], correctIndex: 0, topic: "Bonding", lessonTitle: "Metallic bonding", lessonBody: "In a metal, positive ions are arranged in a lattice surrounded by a 'sea' of delocalised electrons. These free electrons let metals conduct electricity and heat.", simpleBody: "In a metal, there are positive bits sitting in a 'sea' of electrons that can move around freely. These moving electrons let metals carry electricity.", standardBody: "Metallic bonding is positive metal ions surrounded by a sea of free-moving electrons, which lets metals conduct electricity.", tip: "Metal = positive ions + sea of free electrons.")
        ]
    )

    // MARK: Mathematics · Paper 1 (questions 501–510)
    static let maths1 = Paper(
        id: 6, subject: "Mathematics", code: "4024/11", session: "May/June 2026",
        paperTitle: "Paper 1 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 501, stem: "Evaluate 3 + 4 × 2.", options: ["14", "11", "10", "24"], correctIndex: 1, topic: "Order of operations", lessonTitle: "BIDMAS / order of operations", lessonBody: "Multiplication is done before addition. So 4 × 2 = 8 first, then 3 + 8 = 11.", simpleBody: "Always do × before +. First 4 × 2 = 8. Then add the 3: 8 + 3 = 11.", standardBody: "Following the order of operations, do the multiplication first (4 × 2 = 8), then add 3 to get 11.", tip: "Do × and ÷ before + and −."),
            .init(id: 502, stem: "Simplify 3x + 5x − 2x.", options: ["6x", "10x", "8x", "4x"], correctIndex: 0, topic: "Algebra", lessonTitle: "Collecting like terms", lessonBody: "Add and subtract the coefficients of the like terms: 3 + 5 − 2 = 6, giving 6x.", simpleBody: "These all have an x, so just work out the numbers in front: 3 + 5 − 2 = 6. Answer: 6x.", standardBody: "Combine the like terms by adding and subtracting the numbers in front of x: 3 + 5 − 2 = 6, so 6x.", tip: "Just combine the numbers in front of x."),
            .init(id: 503, stem: "What is 25% of 80?", options: ["16", "20", "25", "40"], correctIndex: 1, topic: "Percentages", lessonTitle: "Finding a percentage", lessonBody: "25% is one quarter. A quarter of 80 is 80 ÷ 4 = 20.", simpleBody: "25% means one quarter, the same as splitting into 4 equal parts. 80 ÷ 4 = 20.", standardBody: "25% is a quarter, so divide 80 by 4 to get 20.", tip: "25% = ÷4."),
            .init(id: 504, stem: "Calculate 5² − 3².", options: ["4", "16", "8", "34"], correctIndex: 1, topic: "Powers", lessonTitle: "Squaring numbers", lessonBody: "5² = 25 and 3² = 9. Then 25 − 9 = 16.", simpleBody: "5² means 5 × 5 = 25. 3² means 3 × 3 = 9. Now take away: 25 − 9 = 16.", standardBody: "Work out each square first: 5² = 25 and 3² = 9, then subtract to get 16.", tip: "Square each number first, then subtract."),
            .init(id: 505, stem: "Solve for x: 2x + 3 = 11.", options: ["x = 4", "x = 7", "x = 5", "x = 8"], correctIndex: 0, topic: "Equations", lessonTitle: "Solving linear equations", lessonBody: "Subtract 3 from both sides: 2x = 8. Then divide by 2: x = 4.", simpleBody: "First take away 3 from both sides: 2x = 8. Then split by 2: x = 4.", standardBody: "Take 3 off both sides to get 2x = 8, then divide by 2 to find x = 4.", tip: "Undo +3 first, then undo ×2."),
            .init(id: 506, stem: "The area of a triangle with base 10 cm and height 6 cm is…", options: ["30 cm²", "60 cm²", "16 cm²", "32 cm²"], correctIndex: 0, topic: "Mensuration", lessonTitle: "Area of a triangle", lessonBody: "Area = ½ × base × height = ½ × 10 × 6 = 30 cm².", simpleBody: "For a triangle, area = ½ × base × height. So ½ × 10 × 6 = 30 cm².", standardBody: "Use area = ½ × base × height = ½ × 10 × 6 = 30 cm².", tip: "Don't forget the ½."),
            .init(id: 507, stem: "Write 3/4 as a percentage.", options: ["34%", "43%", "75%", "60%"], correctIndex: 2, topic: "Fractions", lessonTitle: "Fraction to percentage", lessonBody: "3 ÷ 4 = 0.75, and 0.75 × 100 = 75%.", simpleBody: "Divide the top by the bottom: 3 ÷ 4 = 0.75. Times by 100 to get a percent: 75%.", standardBody: "3 ÷ 4 = 0.75, then multiply by 100 to get 75%.", tip: "Divide top by bottom, then ×100."),
            .init(id: 508, stem: "What is the next term in the sequence 2, 5, 8, 11, …?", options: ["12", "13", "14", "15"], correctIndex: 2, topic: "Sequences", lessonTitle: "Linear sequences", lessonBody: "The terms increase by 3 each time (the common difference). 11 + 3 = 14.", simpleBody: "The numbers go up by 3 every time (2, 5, 8, 11 …). So the next one is 11 + 3 = 14.", standardBody: "The sequence goes up by 3 each time, so the next term is 11 + 3 = 14.", tip: "Find the step, then add it on."),
            .init(id: 509, stem: "Find the median of 3, 7, 9, 4, 5.", options: ["4", "5", "7", "9"], correctIndex: 1, topic: "Statistics", lessonTitle: "The median", lessonBody: "Put the values in order: 3, 4, 5, 7, 9. The middle value is 5.", simpleBody: "The median is the middle number. First put them in order: 3, 4, 5, 7, 9. The middle one is 5.", standardBody: "Order the numbers (3, 4, 5, 7, 9); the middle value, 5, is the median.", tip: "Order the data first, then pick the middle."),
            .init(id: 510, stem: "A fair six-sided die is rolled. What is the probability of an even number?", options: ["1/6", "1/3", "1/2", "2/3"], correctIndex: 2, topic: "Probability", lessonTitle: "Simple probability", lessonBody: "The even numbers are 2, 4 and 6 — that is 3 of the 6 faces, so the probability is 3/6 = 1/2.", simpleBody: "A dice has 6 sides. Three of them are even (2, 4, 6). So the chance is 3 out of 6, which is 1/2.", standardBody: "Three of the six faces are even (2, 4, 6), so the probability is 3/6 = 1/2.", tip: "Favourable outcomes ÷ total outcomes.")
        ]
    )

    // MARK: Mathematics · Paper 2 (questions 601–610)
    static let maths2 = Paper(
        id: 7, subject: "Mathematics", code: "4024/12", session: "Oct/Nov 2025",
        paperTitle: "Paper 1 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 601, stem: "Simplify the ratio 12 : 18.", options: ["2 : 3", "3 : 2", "6 : 9", "1 : 2"], correctIndex: 0, topic: "Ratio", lessonTitle: "Simplifying ratios", lessonBody: "Divide both parts by their highest common factor, 6: 12 ÷ 6 = 2 and 18 ÷ 6 = 3, giving 2 : 3.", simpleBody: "Divide both numbers by the same value. Both 12 and 18 divide by 6: that gives 2 : 3.", standardBody: "Divide both sides of the ratio by 6 (their highest common factor) to get 2 : 3.", tip: "Divide both sides by the same number."),
            .init(id: 602, stem: "The circumference of a circle of radius 7 cm is (take π ≈ 22/7)…", options: ["22 cm", "44 cm", "14 cm", "154 cm"], correctIndex: 1, topic: "Mensuration", lessonTitle: "Circumference of a circle", lessonBody: "Circumference = 2πr = 2 × 22/7 × 7 = 44 cm. (154 cm² would be the area.)", simpleBody: "The distance around a circle is 2 × π × radius. Here: 2 × 22/7 × 7 = 44 cm.", standardBody: "Circumference = 2πr = 2 × 22/7 × 7 = 44 cm.", tip: "Circumference uses 2πr; area uses πr²."),
            .init(id: 603, stem: "Expand 2(x + 5).", options: ["2x + 5", "2x + 10", "x + 10", "2x + 7"], correctIndex: 1, topic: "Algebra", lessonTitle: "Expanding brackets", lessonBody: "Multiply everything inside the bracket by 2: 2 × x = 2x and 2 × 5 = 10, giving 2x + 10.", simpleBody: "Multiply the 2 by each thing in the bracket: 2 × x = 2x and 2 × 5 = 10. Answer: 2x + 10.", standardBody: "Multiply both terms in the bracket by 2: 2x + 10.", tip: "Multiply the outside number by each term inside."),
            .init(id: 604, stem: "If y = 3x and x = 4, what is y?", options: ["7", "12", "34", "1"], correctIndex: 1, topic: "Substitution", lessonTitle: "Substituting values", lessonBody: "Replace x with 4: y = 3 × 4 = 12.", simpleBody: "Put 4 where the x is: y = 3 × 4 = 12.", standardBody: "Substitute x = 4 into y = 3x: y = 3 × 4 = 12.", tip: "Swap the letter for its value, then calculate."),
            .init(id: 605, stem: "The interior angles of a triangle add up to…", options: ["90°", "180°", "270°", "360°"], correctIndex: 1, topic: "Geometry", lessonTitle: "Angles in a triangle", lessonBody: "The three interior angles of any triangle always sum to 180°. (A quadrilateral sums to 360°.)", simpleBody: "The three angles inside any triangle always add up to 180°.", standardBody: "The interior angles of a triangle always add up to 180°.", tip: "Triangle = 180°, quadrilateral = 360°."),
            .init(id: 606, stem: "Write 0.2 as a fraction in its simplest form.", options: ["1/2", "1/5", "2/10", "1/4"], correctIndex: 1, topic: "Fractions", lessonTitle: "Decimals to fractions", lessonBody: "0.2 = 2/10, and dividing top and bottom by 2 gives 1/5.", simpleBody: "0.2 is the same as 2/10. Divide top and bottom by 2 to get 1/5.", standardBody: "0.2 = 2/10, which simplifies to 1/5.", tip: "Write over 10, then simplify."),
            .init(id: 607, stem: "Factorise x² + 3x.", options: ["x(x + 3)", "(x + 1)(x + 3)", "x² + 3", "3x²"], correctIndex: 0, topic: "Algebra", lessonTitle: "Common factor", lessonBody: "Both terms share a factor of x. Taking it out gives x(x + 3).", simpleBody: "Both parts have an x in them. Take the x outside the bracket: x(x + 3).", standardBody: "x is common to both terms, so factorising gives x(x + 3).", tip: "Look for a factor common to every term."),
            .init(id: 608, stem: "Find the mean of 4, 8, 6 and 2.", options: ["4", "5", "6", "20"], correctIndex: 1, topic: "Statistics", lessonTitle: "The mean", lessonBody: "Add the values: 4 + 8 + 6 + 2 = 20. Then divide by how many there are: 20 ÷ 4 = 5.", simpleBody: "Add them all up: 4 + 8 + 6 + 2 = 20. There are 4 numbers, so 20 ÷ 4 = 5.", standardBody: "Add the numbers (20) and divide by how many there are (4) to get a mean of 5.", tip: "Mean = total ÷ number of values."),
            .init(id: 609, stem: "Solve 3x = 27.", options: ["x = 6", "x = 9", "x = 3", "x = 24"], correctIndex: 1, topic: "Equations", lessonTitle: "One-step equations", lessonBody: "Divide both sides by 3: x = 27 ÷ 3 = 9.", simpleBody: "Split both sides by 3: 27 ÷ 3 = 9. So x = 9.", standardBody: "Divide both sides by 3 to get x = 9.", tip: "Undo the ×3 by dividing by 3."),
            .init(id: 610, stem: "A car travels 150 km in 3 hours. What is its average speed?", options: ["45 km/h", "50 km/h", "60 km/h", "15 km/h"], correctIndex: 1, topic: "Speed", lessonTitle: "Speed = distance ÷ time", lessonBody: "Average speed = distance ÷ time = 150 ÷ 3 = 50 km/h.", simpleBody: "Speed = distance ÷ time. So 150 km ÷ 3 hours = 50 km/h.", standardBody: "Average speed = distance ÷ time = 150 ÷ 3 = 50 km/h.", tip: "Divide the distance by the time.")
        ]
    )
}

// MARK: - Written (short-answer) papers

/// A single short-answer / structured exam question that a student writes out.
struct WrittenQuestion: Identifiable, Hashable {
    let id: Int
    let number: Int
    let stem: String
    let marks: Int
    /// The marking points an examiner looks for, used to guide AI grading.
    let markScheme: [String]
    /// A model answer shown for self-marking when AI grading is unavailable.
    let exemplar: String
}

/// An exam paper made up of written, examiner-marked questions.
struct WrittenPaper: Identifiable, Hashable {
    let id: Int
    let subject: String
    let code: String
    let session: String
    let paperTitle: String
    let duration: String
    let questions: [WrittenQuestion]

    var totalMarks: Int { questions.reduce(0) { $0 + $1.marks } }
}

extension DemoPaper {
    /// Written short-answer papers, graded on-device by the AI examiner.
    static let writtenPapers: [WrittenPaper] = [biologyWritten]

    // MARK: Biology · Structured (short answer)
    static let biologyWritten = WrittenPaper(
        id: 901, subject: "Biology", code: "5090/22", session: "Oct/Nov 2025",
        paperTitle: "Paper 2 Theory", duration: "45 min",
        questions: [
            .init(id: 9001, number: 1,
                  stem: "Describe how the structure of an alveolus is adapted for efficient gas exchange.",
                  marks: 3,
                  markScheme: [
                    "Large surface area (many alveoli) for exchange",
                    "Walls one cell thick / thin walls give a short diffusion distance",
                    "Moist lining so gases can dissolve",
                    "Rich blood supply / many capillaries maintains a steep concentration gradient"
                  ],
                  exemplar: "Alveoli provide a very large surface area and their walls are only one cell thick, giving a short diffusion distance. The moist lining lets oxygen and carbon dioxide dissolve, and a rich supply of blood capillaries keeps a steep concentration gradient so diffusion stays fast."),
            .init(id: 9002, number: 2,
                  stem: "Explain how water travels from the roots of a plant to its leaves.",
                  marks: 4,
                  markScheme: [
                    "Water enters root hair cells by osmosis",
                    "Water moves across the root into the xylem",
                    "Xylem vessels carry water up the stem",
                    "Transpiration (evaporation from the leaves) creates a pull / tension",
                    "Cohesion between water molecules keeps a continuous column"
                  ],
                  exemplar: "Water enters the root hair cells by osmosis and passes across the root into the xylem. Evaporation of water from the leaves during transpiration creates a pull that draws water up the xylem. Because water molecules stick together by cohesion, a continuous column is pulled all the way from the roots to the leaves."),
            .init(id: 9003, number: 3,
                  stem: "Describe the role of insulin in the control of blood glucose concentration.",
                  marks: 3,
                  markScheme: [
                    "Insulin is secreted by the pancreas",
                    "Released when blood glucose concentration is too high",
                    "Causes the liver (and muscles) to convert glucose into glycogen",
                    "This lowers the blood glucose concentration back to normal"
                  ],
                  exemplar: "Insulin is a hormone released by the pancreas when blood glucose concentration rises too high. It makes the liver and muscle cells take up glucose and convert it into glycogen for storage, which lowers the blood glucose concentration back towards normal."),
            .init(id: 9004, number: 4,
                  stem: "Explain how a population of bacteria can become resistant to an antibiotic through natural selection.",
                  marks: 4,
                  markScheme: [
                    "Variation exists in the population, caused by mutation",
                    "Some bacteria are resistant to the antibiotic by chance",
                    "The antibiotic kills the non-resistant bacteria (selection pressure)",
                    "Resistant bacteria survive and reproduce",
                    "The resistance allele is passed on, so its frequency increases over generations"
                  ],
                  exemplar: "Random mutations produce variation, so a few bacteria are resistant to the antibiotic by chance. When the antibiotic is used it kills the non-resistant bacteria but the resistant ones survive. These survivors reproduce and pass on the resistance allele, so over many generations the proportion of resistant bacteria in the population increases."),
            .init(id: 9005, number: 5,
                  stem: "State two structural features of an artery and explain how each is related to its function.",
                  marks: 3,
                  markScheme: [
                    "Thick, muscular / elastic wall — withstands and maintains high blood pressure",
                    "Wall can stretch and recoil — smooths out the pulsed flow of blood",
                    "Narrow lumen (relative to wall) — helps keep the blood pressure high",
                    "No valves needed — pressure keeps blood flowing in one direction"
                  ],
                  exemplar: "Arteries have thick, muscular and elastic walls that can withstand the high pressure of blood leaving the heart and recoil to keep the blood moving. They also have a relatively narrow lumen, which helps maintain that high pressure as blood is carried away from the heart.")
        ]
    )
}
