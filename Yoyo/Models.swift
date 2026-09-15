import Foundation

/// How much detail a lesson explanation should show.
enum LessonLevel: Int, CaseIterable, Identifiable {
    case simple = 0
    case detailed = 1

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .simple: return "Simple"
        case .detailed: return "Detailed"
        }
    }

    var icon: String {
        switch self {
        case .simple: return "leaf.fill"
        case .detailed: return "book.fill"
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
    /// Plain-language explanation for younger readers: short sentences, hard
    /// words explained, everyday comparisons.
    let simpleBody: String
    /// A fuller teaching explanation: the mechanism, the reasoning and the key
    /// terms, enough to actually learn the topic.
    let detailedBody: String
    let tip: String

    /// The explanation body for the chosen detail level.
    func body(for level: LessonLevel) -> String {
        switch level {
        case .simple: return simpleBody
        case .detailed: return detailedBody
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
            .init(id: 1, stem: "Which feature is found in a plant cell but not in an animal cell?", options: ["Cell membrane", "Cytoplasm", "Cellulose cell wall", "Ribosome"], correctIndex: 2, topic: "Cell structure", lessonTitle: "Plant vs animal cells",
                  simpleBody: "Every cell has a thin outer skin called the cell membrane. Plant cells have something extra: a strong outer wall made of cellulose. Cellulose is a tough fibre (the same stuff that makes plant stems firm), and it gives the plant cell its box-like shape. Animal cells never have this wall, so they look rounder.",
                  detailedBody: "Plant and animal cells share three things: a cell membrane (controls what goes in and out), cytoplasm (the jelly where reactions happen) and ribosomes (which make proteins). Plant cells have extra features on top of these — most importantly a cell wall made of cellulose, which is fully permeable and supports the cell so it keeps a fixed shape. Many plant cells also have chloroplasts for photosynthesis and a large permanent vacuole. The cellulose wall is the one feature here that animal cells can never have, so it is the answer.",
                  tip: "Look for the structure that gives plant cells extra support."),
            .init(id: 2, stem: "What is the main function of red blood cells?", options: ["Defence against pathogens", "Transport of oxygen", "Blood clotting", "Production of hormones"], correctIndex: 1, topic: "Transport in humans", lessonTitle: "Red blood cells",
                  simpleBody: "Red blood cells are like tiny delivery vans for oxygen. They fill up with oxygen in your lungs, travel in the blood to every part of the body, and drop it off. They can do this because they are packed with a red chemical called haemoglobin, which grabs onto oxygen and then lets it go again.",
                  detailedBody: "The main job of a red blood cell is to transport oxygen from the lungs to respiring tissues. Each cell is full of haemoglobin, a red protein that binds to oxygen where there is a lot of it (the lungs) and releases it where there is little (busy tissues) — this reversible binding is the key idea. Red blood cells are well adapted: a biconcave (dented disc) shape gives a large surface area, and having no nucleus leaves more room for haemoglobin. Defence, clotting and hormones are jobs of other cells.",
                  tip: "Think haemoglobin."),
            .init(id: 3, stem: "Which process moves water through a partially permeable membrane from a dilute solution to a more concentrated solution?", options: ["Active transport", "Diffusion", "Osmosis", "Transpiration"], correctIndex: 2, topic: "Movement in and out of cells", lessonTitle: "Osmosis",
                  simpleBody: "Osmosis is a special word for water moving. Imagine a fine net that only lets water through, not bigger particles — that is a 'partially permeable membrane'. Water always drifts from the side with lots of water to the side with less water, until things even out. That movement of water is osmosis.",
                  detailedBody: "Osmosis is the net movement of water molecules across a partially permeable membrane, from a region of higher water potential (a dilute solution, lots of free water) to a region of lower water potential (a concentrated solution, less free water). 'Partially permeable' means the membrane lets small water molecules through but not larger dissolved particles. It is passive, so no energy is needed, and it continues until the water potentials are equal. Because it specifically involves water and a partially permeable membrane, the answer is osmosis, not diffusion or active transport.",
                  tip: "Water + partially permeable membrane = osmosis."),
            .init(id: 4, stem: "Which gas is used by green plants during photosynthesis?", options: ["Carbon dioxide", "Nitrogen", "Oxygen", "Water vapour"], correctIndex: 0, topic: "Photosynthesis", lessonTitle: "Raw materials for photosynthesis",
                  simpleBody: "Plants make their own food instead of eating. They take in a gas called carbon dioxide from the air (through tiny holes in their leaves) and water from the soil. Using the energy in sunlight, they turn these into sugar for food. As they do this, they give out oxygen — the gas we need to breathe.",
                  detailedBody: "Photosynthesis is how green plants make glucose. They use two raw materials — carbon dioxide (taken in through the leaves) and water (taken up by the roots) — together with light energy that is absorbed by the green pigment chlorophyll. The word equation is: carbon dioxide + water → glucose + oxygen. So carbon dioxide is the gas taken IN, while oxygen is released as a by-product. Recalling the equation makes it clear the gas used is carbon dioxide.",
                  tip: "Recall the word equation for photosynthesis."),
            .init(id: 5, stem: "Where does most aerobic respiration occur inside a cell?", options: ["Cell wall", "Mitochondrion", "Nucleus", "Vacuole"], correctIndex: 1, topic: "Respiration", lessonTitle: "Mitochondria and energy",
                  simpleBody: "Cells need energy to work, and they make it in tiny parts called mitochondria. You can think of a mitochondrion as a little power station inside the cell. Cells that work hard, like the muscle cells that move your body, are packed with lots of them.",
                  detailedBody: "Aerobic respiration is the process that releases energy from glucose using oxygen, and most of it happens inside the mitochondria. A mitochondrion is a small organelle often called the cell's 'powerhouse' because it supplies the energy the cell needs. Cells with high energy demands — such as muscle cells or sperm cells — contain very large numbers of mitochondria. The cell wall, nucleus and vacuole do not carry out respiration, so the mitochondrion is the answer.",
                  tip: "The 'powerhouse' clue points to mitochondria."),
            .init(id: 6, stem: "Which enzyme digests starch?", options: ["Amylase", "Lipase", "Pepsin", "Trypsin"], correctIndex: 0, topic: "Nutrition", lessonTitle: "Digestive enzymes",
                  simpleBody: "Enzymes are tiny helpers that cut big food molecules into small ones so your body can use them. Starch (found in bread, rice and potatoes) is broken down by an enzyme called amylase. Amylase turns the big starch into small sugar.",
                  detailedBody: "Digestive enzymes each break down one type of food. Amylase is the enzyme that digests starch, breaking it into smaller sugars such as maltose; it is made in the salivary glands and the pancreas. The others do different jobs: lipase breaks down fats into fatty acids and glycerol, while proteases such as pepsin and trypsin break down proteins into amino acids. As the question asks about starch, the answer is amylase.",
                  tip: "Amylase sounds like amylose, a component of starch."),
            .init(id: 7, stem: "What happens to the pupil in bright light?", options: ["It gets larger", "It gets smaller", "It changes colour", "It moves towards the lens"], correctIndex: 1, topic: "Coordination and response", lessonTitle: "The pupil reflex",
                  simpleBody: "The pupil is the black circle in the middle of your eye that lets light in. In bright light the pupil shrinks so that not too much light gets in and hurts the back of your eye. In the dark it opens wide again to let more light in so you can see.",
                  detailedBody: "The size of the pupil is controlled automatically by the iris (the coloured ring) in a reflex. In bright light the circular muscles of the iris contract and the radial muscles relax, making the pupil smaller. This reduces the amount of light entering the eye and protects the light-sensitive retina from damage. In dim light the opposite happens and the pupil widens. So in bright light the pupil gets smaller.",
                  tip: "Bright light → less light should enter."),
            .init(id: 8, stem: "Which blood vessel carries blood away from the heart?", options: ["Artery", "Capillary", "Vein", "Venule"], correctIndex: 0, topic: "Circulation", lessonTitle: "Arteries and veins",
                  simpleBody: "Your blood travels around the body in tubes. The tubes that carry blood AWAY from the heart are called arteries. A quick way to remember it: Artery = Away. Veins are the tubes that bring blood back to the heart.",
                  detailedBody: "Blood vessels come in three main types. Arteries carry blood away from the heart, usually at high pressure, so they have thick, muscular and elastic walls. Veins carry blood back towards the heart at lower pressure and contain valves to stop backflow. Capillaries are tiny, thin-walled vessels where substances are exchanged with the tissues, linking arteries and veins. The vessel that carries blood away from the heart is the artery.",
                  tip: "Artery = Away."),
            .init(id: 9, stem: "Which condition is required for seed germination?", options: ["Carbon dioxide", "Light in every species", "Water", "Chlorophyll"], correctIndex: 2, topic: "Plant reproduction", lessonTitle: "Germination",
                  simpleBody: "A seed is like a tiny plant asleep inside a package. To wake up and start growing (this is called germination) it needs water, air and warmth. Water is the most important trigger. A seed does not always need light to start growing.",
                  detailedBody: "Germination is when a seed starts to grow into a seedling. Three conditions are needed: water, oxygen and a suitable (warm) temperature. Water is essential because it activates the enzymes inside the seed, which then break down stored food for the growing embryo; oxygen is needed for respiration to release energy. Light is not a general requirement — some seeds need it, but many do not — so the condition always required from this list is water.",
                  tip: "Think about what activates enzymes inside the seed."),
            .init(id: 10, stem: "Which statement about a dominant allele is correct?", options: ["It is always more common", "It is expressed in a heterozygote", "It must be beneficial", "It is only found on the X chromosome"], correctIndex: 1, topic: "Inheritance", lessonTitle: "Dominant and recessive alleles",
                  simpleBody: "You get two copies of each gene, one from each parent. Some versions (called alleles) are 'dominant', which means they are the boss — if you have even one dominant copy, that is the one that shows up. A 'recessive' version only shows if you have two copies of it.",
                  detailedBody: "An allele is a version of a gene. A dominant allele is expressed (shows in the phenotype) whenever at least one copy is present — including in a heterozygote, where the two alleles are different. A recessive allele is usually only expressed when two copies are present (homozygous recessive). Being dominant is about whether the allele shows, not about how common or how useful it is, and dominant alleles are not tied to the X chromosome. So the correct statement is that it is expressed in a heterozygote.",
                  tip: "Focus on expression, not frequency or usefulness."),
            .init(id: 11, stem: "Which organism is a decomposer?", options: ["Grass", "Hawk", "Mushroom", "Rabbit"], correctIndex: 2, topic: "Ecology", lessonTitle: "Decomposers",
                  simpleBody: "Decomposers are living things that break down dead plants and animals and rotting waste. A mushroom is a kind of fungus, and fungi are decomposers. They are like nature's clean-up crew, recycling dead material back into the soil.",
                  detailedBody: "Decomposers are organisms — mainly fungi and bacteria — that feed on dead organic matter and waste. As they break it down they release mineral ions (such as nitrates) back into the soil, where plants can reuse them, so they are essential for recycling nutrients. In this list, grass is a producer while the rabbit and hawk are consumers; the mushroom is a fungus, which makes it the decomposer.",
                  tip: "Look for a fungus or bacterium."),
            .init(id: 12, stem: "Which change would usually increase the rate of an enzyme-controlled reaction up to its optimum?", options: ["Lowering substrate concentration", "Increasing temperature", "Removing the enzyme", "Making the solution extremely acidic"], correctIndex: 1, topic: "Enzymes", lessonTitle: "Temperature and enzymes",
                  simpleBody: "Enzymes are helpers that work faster when it is warmer — but only up to their favourite temperature. Warmth makes the tiny particles move around and bump into each other more, so the reaction speeds up. (If it gets too hot, though, the enzyme stops working.)",
                  detailedBody: "Raising the temperature, up to the optimum, increases the rate of an enzyme-controlled reaction. This is because heat gives the enzyme and substrate molecules more kinetic energy, so they move faster and collide more often, forming more enzyme–substrate complexes. Beyond the optimum the enzyme starts to denature — its active site changes shape and no longer fits the substrate — so activity falls. The phrase 'up to its optimum' tells you that increasing temperature is the change that speeds it up.",
                  tip: "The key phrase is 'up to its optimum'.")
        ]
    )

    // MARK: Biology · Paper 2 (questions 101–108)
    static let biology2 = Paper(
        id: 2, subject: "Biology", code: "5090/12", session: "Oct/Nov 2025",
        paperTitle: "Paper 2 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 101, stem: "Enzymes are biological catalysts. What type of molecule are they made from?", options: ["Proteins", "Lipids", "Carbohydrates", "Nucleic acids"], correctIndex: 0, topic: "Enzymes", lessonTitle: "What enzymes are made of",
                  simpleBody: "Enzymes are made of protein. Their job is to speed up reactions in the body, like helping to break down food. The clever part is that they are not used up when they work, so the same enzyme can be used over and over again.",
                  detailedBody: "Enzymes are biological catalysts made of protein. A catalyst speeds up a reaction without being changed or used up itself, so one enzyme molecule can work again and again. What makes each enzyme act on only one substrate is its precise three-dimensional shape, especially the active site into which the substrate fits (the 'lock and key' idea). Because they are catalysts whose shape is so important, the material they are built from is protein.",
                  tip: "Enzyme names often end in '-ase', but the material is protein."),
            .init(id: 102, stem: "Which feature of the alveoli increases the rate of gas exchange?", options: ["Thick muscular walls", "A large surface area", "A dry lining", "Few blood capillaries"], correctIndex: 1, topic: "Gas exchange", lessonTitle: "Alveoli and gas exchange",
                  simpleBody: "Your lungs are filled with millions of tiny air bags called alveoli. Because there are so many of them, together they give a huge surface for oxygen to pass into the blood quickly. Their walls are also super thin, which helps the gases move across fast.",
                  detailedBody: "Alveoli are the tiny air sacs where gas exchange happens, and they are adapted to make it fast. The feature that increases the rate is their very large surface area (there are millions of them). They also have walls only one cell thick (a short diffusion distance), a moist lining so gases can dissolve, and a rich blood capillary supply that keeps a steep concentration gradient. Thick walls, a dry lining or few capillaries would all slow exchange down, so the correct adaptation is a large surface area.",
                  tip: "Big surface area + thin walls = fast diffusion."),
            .init(id: 103, stem: "Which organ removes urea from the blood?", options: ["Liver", "Kidney", "Lungs", "Pancreas"], correctIndex: 1, topic: "Excretion", lessonTitle: "Excreting urea",
                  simpleBody: "Your kidneys are the body's filters. They clean the blood by taking out a waste chemical called urea, and get rid of it in your urine (wee). You have two kidneys, one on each side of your back.",
                  detailedBody: "Urea is a nitrogen-containing waste made in the liver when excess amino acids are broken down (a process called deamination). It is carried in the blood to the kidneys, which filter it out and remove it from the body dissolved in urine. This removal of metabolic waste is called excretion. The lungs excrete carbon dioxide and the liver makes the urea, but the organ that removes urea from the blood is the kidney.",
                  tip: "Liver makes urea; kidney removes it."),
            .init(id: 104, stem: "Water moves up the xylem of a plant mainly because of which process?", options: ["Translocation", "Transpiration pull", "Active transport", "Osmosis in the phloem"], correctIndex: 1, topic: "Transport in plants", lessonTitle: "The transpiration stream",
                  simpleBody: "Plants move water from their roots all the way up to their leaves. As water dries off (evaporates) from the leaves, it pulls the water below it upwards — a bit like sucking a drink up a straw. This pulling is caused by transpiration.",
                  detailedBody: "Water travels up the xylem vessels because of the transpiration pull. Water evaporates from cell surfaces inside the leaf and diffuses out through the stomata (transpiration); this loss creates a tension, or 'pull', at the top of the plant. Because water molecules stick together by cohesion, they form a continuous column that is dragged up from the roots to replace the water lost. Translocation happens in the phloem and moves sugars, not water up the xylem, so the answer is transpiration pull.",
                  tip: "Evaporation at the top pulls water up."),
            .init(id: 105, stem: "Which hormone lowers blood glucose concentration?", options: ["Adrenaline", "Insulin", "Glucagon", "Testosterone"], correctIndex: 1, topic: "Hormones", lessonTitle: "Controlling blood glucose",
                  simpleBody: "Insulin is a chemical messenger (a hormone). When there is too much sugar in your blood, insulin gives the signal to store the extra sugar away. This makes the blood sugar level go back down to normal.",
                  detailedBody: "Insulin is a hormone secreted by the pancreas when blood glucose concentration rises too high, for example after a meal. It travels in the blood and makes the liver and muscle cells take up glucose and convert it into glycogen for storage, and it helps cells use glucose in respiration. The overall effect is to lower blood glucose back towards normal — an example of homeostasis. Glucagon has the opposite effect (raising glucose), so the hormone that lowers it is insulin.",
                  tip: "Insulin puts glucose 'in' to storage."),
            .init(id: 106, stem: "Which cells produce antibodies to fight infection?", options: ["Red blood cells", "Lymphocytes", "Platelets", "Nerve cells"], correctIndex: 1, topic: "Disease and immunity", lessonTitle: "Antibodies and lymphocytes",
                  simpleBody: "Some of your white blood cells, called lymphocytes, make tiny weapons called antibodies. Antibodies stick onto germs like a label, which helps the body find and destroy them. This is part of how you fight off infections.",
                  detailedBody: "Lymphocytes are a type of white blood cell that produce antibodies. Antibodies are proteins with a specific shape that lock onto the antigens on the surface of a pathogen; this marks the pathogen for destruction and can clump pathogens together. After an infection, memory lymphocytes remain, giving future immunity so the response is faster next time. Red blood cells carry oxygen and platelets help clotting, so the cells that make antibodies are the lymphocytes.",
                  tip: "Lymphocytes make the 'locks' for antigens."),
            .init(id: 107, stem: "Which best describes natural selection?", options: ["Organisms choose to change", "The best-adapted organisms survive and reproduce", "All offspring are identical", "Characteristics are always inherited equally"], correctIndex: 1, topic: "Variation and selection", lessonTitle: "Natural selection",
                  simpleBody: "Living things in a group are all slightly different from each other. The ones whose features suit their surroundings best are more likely to stay alive and have babies. Those babies inherit the helpful features, so over time the whole group changes. This is natural selection.",
                  detailedBody: "Natural selection works like this: within a population there is variation, and resources are limited so there is competition to survive. Individuals with characteristics best suited (adapted) to their environment are more likely to survive, reproduce and pass on the alleles for those useful characteristics. Over many generations these advantageous alleles become more common in the population. Organisms do not choose to change and offspring are not identical, so the best description is that the best-adapted organisms survive and reproduce.",
                  tip: "Think 'survival of the best adapted'."),
            .init(id: 108, stem: "Burning fossil fuels adds which gas that contributes most to the enhanced greenhouse effect?", options: ["Oxygen", "Carbon dioxide", "Nitrogen", "Argon"], correctIndex: 1, topic: "Human impact", lessonTitle: "The greenhouse effect",
                  simpleBody: "When we burn fuels like coal, oil, petrol and gas, they release a gas called carbon dioxide. This gas builds up in the air and traps heat, like a blanket around the Earth, which makes the planet warmer.",
                  detailedBody: "Burning fossil fuels (coal, oil and natural gas) releases carbon dioxide into the atmosphere. Carbon dioxide is a greenhouse gas: it traps heat energy that would otherwise escape from the Earth, so rising levels enhance the greenhouse effect and lead to global warming and climate change. Oxygen, nitrogen and argon do not trap heat in this way. So the gas added by burning fossil fuels that contributes most here is carbon dioxide.",
                  tip: "Fossil fuels + carbon = carbon dioxide.")
        ]
    )

    // MARK: Biology · Paper 3 (questions 301–310)
    static let biology3 = Paper(
        id: 4, subject: "Biology", code: "5090/13", session: "May/June 2025",
        paperTitle: "Paper 1 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 301, stem: "Which structure controls what enters and leaves a cell?", options: ["Cell wall", "Cell membrane", "Nucleus", "Vacuole"], correctIndex: 1, topic: "Cell structure", lessonTitle: "The cell membrane",
                  simpleBody: "Around every cell is a thin skin called the cell membrane. It acts like a gatekeeper, deciding what is allowed in and out of the cell. It is 'partially permeable', which means only some things can pass through it.",
                  detailedBody: "The cell membrane surrounds the cell and controls the movement of substances into and out of it because it is partially permeable — it lets some molecules through (like water and oxygen) but blocks others. This is different from the plant cell wall, which is fully permeable and only provides support and shape, so it does not control what enters. The nucleus stores genetic material and the vacuole stores cell sap. Therefore the structure that controls entry and exit is the cell membrane.",
                  tip: "Control of entry/exit = membrane, not wall."),
            .init(id: 302, stem: "The movement of glucose into a cell against a concentration gradient uses…", options: ["Diffusion", "Osmosis", "Active transport", "Filtration"], correctIndex: 2, topic: "Movement in and out of cells", lessonTitle: "Active transport",
                  simpleBody: "Usually things drift from where there is a lot to where there is little. But sometimes a cell needs to pull something IN even when there is already plenty inside. Doing this 'uphill' move needs energy, and it is called active transport.",
                  detailedBody: "Active transport is the movement of a substance across a membrane from a low concentration to a high concentration — that is, against the concentration gradient. Because it goes 'uphill', it requires energy from respiration (using ATP) and carrier proteins in the membrane. This is different from diffusion and osmosis, which are passive and move substances down the gradient without energy. Root hair cells use active transport to absorb mineral ions. Since the glucose here moves against the gradient, the answer is active transport.",
                  tip: "Against the gradient = energy = active transport."),
            .init(id: 303, stem: "Which food group is the body's main source of energy?", options: ["Proteins", "Carbohydrates", "Vitamins", "Minerals"], correctIndex: 1, topic: "Nutrition", lessonTitle: "Energy from food",
                  simpleBody: "Foods like bread, rice, pasta and potatoes are full of carbohydrates. Carbohydrates are the body's main fuel — they give you the energy to move, play and think.",
                  detailedBody: "Carbohydrates, such as starch and sugars, are the body's main source of energy; they are broken down into glucose, which is used in respiration to release energy. Fats are also an energy store and actually contain more energy per gram, but they are not the main day-to-day source (they are also used for insulation). Proteins are mainly needed for growth and repair, while vitamins and minerals are only needed in small amounts. So the main energy food group is carbohydrates.",
                  tip: "Carbohydrates are the go-to fuel."),
            .init(id: 304, stem: "Deoxygenated blood is carried from the heart to the lungs by the…", options: ["Aorta", "Pulmonary artery", "Pulmonary vein", "Vena cava"], correctIndex: 1, topic: "Circulation", lessonTitle: "Pulmonary circulation",
                  simpleBody: "The pulmonary artery is a special tube. It carries blood that has no oxygen left in it from the heart to the lungs, so the blood can pick up fresh oxygen. ('Deoxygenated' just means the oxygen has been used up.)",
                  detailedBody: "Blood returning from the body has had its oxygen used up, so it is deoxygenated. The heart pumps this blood to the lungs through the pulmonary artery so it can collect more oxygen. This vessel is unusual: arteries normally carry oxygenated blood, but the pulmonary artery is the exception you are expected to remember. The pulmonary vein does the opposite, returning oxygenated blood to the heart. So the vessel carrying deoxygenated blood to the lungs is the pulmonary artery.",
                  tip: "Arteries leave the heart — even the pulmonary artery."),
            .init(id: 305, stem: "Which part of a leaf is the main site of photosynthesis?", options: ["Waxy cuticle", "Palisade mesophyll", "Xylem", "Lower epidermis"], correctIndex: 1, topic: "Photosynthesis", lessonTitle: "Palisade cells",
                  simpleBody: "A leaf is where a plant makes its food. Near the top of the leaf are tall cells that are packed with tiny green parts called chloroplasts. They catch the most sunlight, so most food-making (photosynthesis) happens there.",
                  detailedBody: "The main site of photosynthesis in a leaf is the palisade mesophyll layer, near the upper surface. These column-shaped cells are packed with chloroplasts, which contain chlorophyll to absorb light, and being near the top means they receive the most light. The waxy cuticle is a transparent protective layer (it does not photosynthesise), the xylem transports water, and the lower epidermis contains the stomata. So most photosynthesis takes place in the palisade mesophyll.",
                  tip: "Most chloroplasts = palisade layer."),
            .init(id: 306, stem: "A reflex action is best described as a response that is…", options: ["Slow and voluntary", "Rapid and automatic", "Always learned", "Controlled by hormones"], correctIndex: 1, topic: "Coordination and response", lessonTitle: "Reflex actions",
                  simpleBody: "A reflex is something your body does really fast, all by itself, without you thinking about it — like quickly pulling your hand away from something hot. It happens automatically to protect you from harm.",
                  detailedBody: "A reflex action is a rapid, automatic response to a stimulus that does not involve conscious thought. It follows a fixed pathway called the reflex arc: receptor → sensory neurone → relay neurone (in the spinal cord) → motor neurone → effector. Because it skips conscious decision-making, it is very fast, which helps protect the body from danger (for example the withdrawal reflex from a hot object). So a reflex is best described as rapid and automatic.",
                  tip: "Reflex = fast + automatic + protective."),
            .init(id: 307, stem: "Which gas is present in a greater amount in exhaled air than in inhaled air?", options: ["Oxygen", "Nitrogen", "Carbon dioxide", "Argon"], correctIndex: 2, topic: "Gas exchange", lessonTitle: "Inhaled vs exhaled air",
                  simpleBody: "The air you breathe out is not the same as the air you breathe in. When you breathe out, there is more carbon dioxide in the air, because your body makes carbon dioxide as a waste gas.",
                  detailedBody: "Compared with inhaled (breathed-in) air, exhaled (breathed-out) air contains more carbon dioxide and more water vapour, and less oxygen. This is because the body uses oxygen in respiration and produces carbon dioxide as a waste product, which is removed at the lungs. The amount of nitrogen stays roughly the same because it is not used. So the gas that increases in exhaled air is carbon dioxide.",
                  tip: "Respiration produces carbon dioxide."),
            .init(id: 308, stem: "The genetic material of a eukaryotic cell is found mainly in the…", options: ["Cytoplasm", "Nucleus", "Cell membrane", "Ribosomes"], correctIndex: 1, topic: "Inheritance", lessonTitle: "Where DNA is stored",
                  simpleBody: "The nucleus is the control centre of the cell — a bit like the brain of the cell. It holds the instructions, called DNA, that tell the cell what to do and how to grow.",
                  detailedBody: "In eukaryotic cells (animal and plant cells) the genetic material is stored in the nucleus as chromosomes, which are made of DNA. The DNA carries the instructions (genes) that control the cell's activities and are copied when the cell divides. The cytoplasm is where many reactions happen and the ribosomes make proteins, but they do not store the main genetic material. So the genetic material is found mainly in the nucleus.",
                  tip: "Nucleus = the cell's control centre."),
            .init(id: 309, stem: "Scurvy is caused by a lack of which vitamin?", options: ["Vitamin A", "Vitamin C", "Vitamin D", "Vitamin K"], correctIndex: 1, topic: "Nutrition", lessonTitle: "Vitamin deficiencies",
                  simpleBody: "Vitamins are things your body needs in small amounts to stay healthy. If you do not get enough vitamin C (found in oranges and other fruit), you can get an illness called scurvy. One sign of scurvy is bleeding gums.",
                  detailedBody: "Scurvy is a deficiency disease caused by a lack of vitamin C, which the body needs to make strong connective tissue; symptoms include bleeding gums and poor wound healing. Vitamin C is found in fresh fruit and vegetables such as citrus fruits. Other shortages cause different diseases — a lack of vitamin D causes rickets (weak bones) and a lack of vitamin A can cause night blindness — so the vitamin missing in scurvy is vitamin C.",
                  tip: "C for scurvy; D for rickets."),
            .init(id: 310, stem: "In a food chain, the arrows show the direction of…", options: ["Energy flow", "Movement of animals", "Water flow", "Carbon dioxide"], correctIndex: 0, topic: "Ecology", lessonTitle: "Reading a food chain",
                  simpleBody: "A food chain shows who eats what. The arrows are important: they point from the food to the animal that eats it, showing which way the energy travels as one thing is eaten by another.",
                  detailedBody: "In a food chain the arrows represent the direction of energy flow (and the transfer of biomass). Each arrow points from the organism being eaten to the organism that eats it — for example grass → rabbit → fox — because that is the direction energy passes along the chain, starting from the producer that captured light energy. The arrows do not show the movement of animals or of water. So the arrows show the direction of energy flow.",
                  tip: "Arrows follow the energy, from prey to predator.")
        ]
    )

    // MARK: Chemistry · Paper 1 (questions 201–208)
    static let chemistry1 = Paper(
        id: 3, subject: "Chemistry", code: "5070/11", session: "May/June 2026",
        paperTitle: "Paper 1 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 201, stem: "The number of protons in an atom is known as its…", options: ["Mass number", "Atomic number", "Neutron number", "Isotope number"], correctIndex: 1, topic: "Atomic structure", lessonTitle: "Atomic number",
                  simpleBody: "In the middle of every atom are tiny particles called protons. The number of protons is called the atomic number. It is like the atom's ID number — it tells you exactly which element the atom is.",
                  detailedBody: "The atomic number (also called the proton number) is the number of protons in the nucleus of an atom, and it defines which element the atom is — for example every carbon atom has 6 protons. In a neutral atom it also equals the number of electrons. Do not confuse it with the mass number, which is the total number of protons plus neutrons. So the number of protons is the atomic number.",
                  tip: "Protons = atomic number = the element's identity."),
            .init(id: 202, stem: "Which type of bonding holds sodium chloride together?", options: ["Covalent", "Ionic", "Metallic", "Hydrogen"], correctIndex: 1, topic: "Bonding", lessonTitle: "Ionic bonding",
                  simpleBody: "Table salt (sodium chloride) is held together by ionic bonding. One atom gives an electron to the other. This gives them opposite electric charges (+ and −), and opposite charges pull towards each other, sticking them together.",
                  detailedBody: "Sodium chloride is held together by ionic bonding. A sodium atom (a metal) transfers one electron to a chlorine atom (a non-metal); sodium becomes a positive ion (Na⁺) and chlorine becomes a negative ion (Cl⁻). The strong electrostatic attraction between these oppositely charged ions is the ionic bond, and it holds the ions in a giant lattice. As a rule, a metal combined with a non-metal gives ionic bonding, so the answer is ionic.",
                  tip: "Metal + non-metal usually means ionic."),
            .init(id: 203, stem: "What is the approximate pH of a strong acid?", options: ["Exactly 7", "Below 7", "Above 7", "Exactly 14"], correctIndex: 1, topic: "Acids and bases", lessonTitle: "The pH scale",
                  simpleBody: "The pH scale is a way of measuring how acidic something is, using numbers from 0 to 14. Acids have a low number, below 7. A strong acid is very low, close to 0 or 1.",
                  detailedBody: "The pH scale runs from 0 to 14 and measures how acidic or alkaline a solution is. Acids have a pH below 7, and the stronger the acid the lower the pH, so a strong acid is around 0–1. A pH of exactly 7 is neutral (like pure water), and values above 7 are alkaline. So the approximate pH of a strong acid is below 7.",
                  tip: "Acid = below 7; alkali = above 7."),
            .init(id: 204, stem: "How does the reactivity of Group I metals change going down the group?", options: ["It decreases", "It increases", "It stays the same", "It increases then decreases"], correctIndex: 1, topic: "The Periodic Table", lessonTitle: "Group I reactivity",
                  simpleBody: "Group I metals are a family of very reactive metals. As you go DOWN the list, they get even more reactive. That is because their outer electron is further away from the middle and easier to lose.",
                  detailedBody: "The Group I metals (the alkali metals) become more reactive as you go down the group. Their reactions involve losing the single outer electron. Lower down the group the atoms are larger, so the outer electron is further from the nucleus and more shielded by inner shells; this means it is held less tightly and lost more easily, making the metal more reactive. So going down Group I the reactivity increases.",
                  tip: "Further from the nucleus = easier to lose the electron."),
            .init(id: 205, stem: "What is the relative formula mass of water, H₂O? (Aᵣ: H = 1, O = 16)", options: ["16", "17", "18", "20"], correctIndex: 2, topic: "Stoichiometry", lessonTitle: "Relative formula mass",
                  simpleBody: "Water is written as H₂O. That means it has two hydrogen atoms and one oxygen atom joined together. To find its mass, add up the atoms: 1 + 1 + 16 = 18.",
                  detailedBody: "The relative formula mass (Mr) is found by adding up the relative atomic masses of every atom in the formula. Water, H₂O, contains two hydrogen atoms and one oxygen atom. Using the values H = 1 and O = 16: (2 × 1) + (1 × 16) = 2 + 16 = 18. So the relative formula mass of water is 18.",
                  tip: "Count every atom, then add the masses."),
            .init(id: 206, stem: "Increasing which factor generally increases the rate of a reaction?", options: ["Lower temperature", "Larger particle size", "Higher concentration", "Removing the catalyst"], correctIndex: 2, topic: "Rates of reaction", lessonTitle: "Speeding up reactions",
                  simpleBody: "A reaction goes faster when the liquid is more concentrated (more crowded with particles). With more particles squeezed into the same space, they bump into each other more often, so the reaction speeds up.",
                  detailedBody: "Reactions happen when particles collide with enough energy. Increasing the concentration puts more reactant particles into the same volume, so collisions happen more frequently and the rate of reaction increases. Lowering the temperature or using larger particles (less surface area) would slow the reaction down, and removing a catalyst also slows it. So the factor that increases the rate is higher concentration.",
                  tip: "More frequent collisions = faster reaction."),
            .init(id: 207, stem: "During electrolysis, positively charged ions move towards the…", options: ["Anode", "Cathode", "Electrolyte", "Battery"], correctIndex: 1, topic: "Electrolysis", lessonTitle: "Electrolysis basics",
                  simpleBody: "Electrolysis uses electricity to split a substance apart. The positive bits are pulled towards the negative side, which is called the cathode, because opposite charges attract.",
                  detailedBody: "During electrolysis an electric current is passed through a molten or dissolved ionic compound, and the ions move to the electrodes. Positive ions (cations) are attracted to the negatively charged electrode, the cathode, where they gain electrons. Negative ions (anions) move to the positively charged electrode, the anode. Since opposite charges attract, positive ions move towards the cathode.",
                  tip: "Cations (positive) go to the cathode (negative)."),
            .init(id: 208, stem: "What is the general formula for the alkanes?", options: ["CₙH₂ₙ", "CₙH₂ₙ₊₂", "CₙH₂ₙ₋₂", "CₙHₙ"], correctIndex: 1, topic: "Organic chemistry", lessonTitle: "The alkane series",
                  simpleBody: "Alkanes are molecules made only from carbon and hydrogen, joined by single bonds. They follow a pattern: however many carbons there are, you can work out the hydrogens using CₙH₂ₙ₊₂. Methane, CH₄, is the simplest one.",
                  detailedBody: "Alkanes are a homologous series of saturated hydrocarbons — 'saturated' means they contain only single covalent bonds between carbon atoms. Every member fits the general formula CₙH₂ₙ₊₂: for example methane is CH₄ (n = 1), ethane is C₂H₆ (n = 2) and propane is C₃H₈ (n = 3). This differs from alkenes (CₙH₂ₙ), which have a double bond. So the general formula for the alkanes is CₙH₂ₙ₊₂.",
                  tip: "Alkanes are saturated: CₙH₂ₙ₊₂.")
        ]
    )

    // MARK: Chemistry · Paper 2 (questions 401–410)
    static let chemistry2 = Paper(
        id: 5, subject: "Chemistry", code: "5070/12", session: "Oct/Nov 2025",
        paperTitle: "Paper 1 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 401, stem: "Which sub-atomic particle has a negative charge?", options: ["Proton", "Neutron", "Electron", "Nucleus"], correctIndex: 2, topic: "Atomic structure", lessonTitle: "Charges of particles",
                  simpleBody: "Atoms are made of three kinds of tiny particle. The electron is the one with a negative (−) charge, and it whizzes around the outside of the atom. Protons are positive and neutrons have no charge.",
                  detailedBody: "Atoms are made of three sub-atomic particles. Electrons carry a negative charge and move around the nucleus in shells (energy levels). Inside the nucleus, protons carry a positive charge and neutrons have no charge (they are neutral). The nucleus overall is positive because of its protons. So the particle with a negative charge is the electron.",
                  tip: "Electron = negative."),
            .init(id: 402, stem: "A substance that speeds up a reaction but is left unchanged at the end is a…", options: ["Reactant", "Catalyst", "Product", "Solvent"], correctIndex: 1, topic: "Rates of reaction", lessonTitle: "Catalysts",
                  simpleBody: "A catalyst is something that makes a reaction go faster but is not used up itself. Because it is left unchanged at the end, you can use the same catalyst again and again.",
                  detailedBody: "A catalyst is a substance that increases the rate of a chemical reaction but is not used up in the process, so it can be reused. It works by providing an alternative reaction pathway with a lower activation energy, meaning more collisions have enough energy to react. Enzymes are biological catalysts. A reactant gets used up and a product is made, so the substance that speeds things up while staying unchanged is a catalyst.",
                  tip: "Catalyst helps but is not consumed."),
            .init(id: 403, stem: "What is formed when a metal reacts with oxygen?", options: ["An acid", "A metal oxide", "A salt", "Hydrogen"], correctIndex: 1, topic: "Chemical reactions", lessonTitle: "Metal + oxygen",
                  simpleBody: "When a metal joins with oxygen from the air, it makes something called a metal oxide. For example, when magnesium burns it joins with oxygen to make magnesium oxide.",
                  detailedBody: "When a metal reacts with oxygen it forms a metal oxide — for example magnesium + oxygen → magnesium oxide (2Mg + O₂ → 2MgO). Metal oxides are generally basic (the opposite of acidic). This is a type of oxidation reaction. Acids and hydrogen come from other kinds of reaction, such as a metal reacting with an acid, so a metal reacting with oxygen forms a metal oxide.",
                  tip: "Metal + oxygen → metal oxide."),
            .init(id: 404, stem: "Which is the correct laboratory test for oxygen gas?", options: ["It bleaches damp litmus paper", "It relights a glowing splint", "It pops with a lit splint", "It turns limewater milky"], correctIndex: 1, topic: "Gas tests", lessonTitle: "Testing for oxygen",
                  simpleBody: "To test if a gas is oxygen, take a wooden splint that is glowing (but not flaming) and put it into the gas. If the splint bursts back into flame, the gas is oxygen.",
                  detailedBody: "The laboratory test for oxygen is to place a glowing splint into the gas: oxygen relights the glowing splint because it supports combustion. It helps to know the other common gas tests too — hydrogen gives a squeaky 'pop' with a lit splint, carbon dioxide turns limewater milky (cloudy), and chlorine bleaches damp litmus paper. So the correct test for oxygen is that it relights a glowing splint.",
                  tip: "Glowing splint relights in oxygen."),
            .init(id: 405, stem: "The products of the complete combustion of a hydrocarbon are…", options: ["Carbon monoxide and water", "Carbon dioxide and water", "Carbon and hydrogen", "Hydrogen only"], correctIndex: 1, topic: "Organic chemistry", lessonTitle: "Complete combustion",
                  simpleBody: "When a fuel burns with plenty of air, it burns completely. This makes two things: carbon dioxide gas and water. This full burning is called complete combustion.",
                  detailedBody: "Complete combustion happens when a hydrocarbon burns in a plentiful supply of oxygen, producing carbon dioxide and water (for example CH₄ + 2O₂ → CO₂ + 2H₂O), and it releases the most energy. If there is not enough oxygen, incomplete combustion occurs instead, producing carbon monoxide (a toxic gas) and/or soot (carbon). So the products of complete combustion of a hydrocarbon are carbon dioxide and water.",
                  tip: "Plenty of oxygen → CO₂ + H₂O."),
            .init(id: 406, stem: "Which technique is used to obtain pure water from salt solution?", options: ["Filtration", "Simple distillation", "Chromatography", "Decanting"], correctIndex: 1, topic: "Separation techniques", lessonTitle: "Distillation",
                  simpleBody: "To get pure water out of salty water, you boil the water so it turns into steam, leaving the salt behind. Then you cool the steam so it turns back into pure water. This method is called distillation.",
                  detailedBody: "To obtain pure water from a salt solution you use simple distillation. The solution is heated so the water boils and evaporates, leaving the dissolved salt behind (salt has a much higher boiling point). The water vapour then passes into a condenser where it cools and condenses back into liquid pure water. Filtration would not work because the salt is dissolved, not an insoluble solid. So the technique is simple distillation.",
                  tip: "Distillation separates a dissolved solute from its solvent."),
            .init(id: 407, stem: "In the reactivity series, which of these metals is the most reactive?", options: ["Copper", "Iron", "Potassium", "Gold"], correctIndex: 2, topic: "The Periodic Table", lessonTitle: "Reactivity series",
                  simpleBody: "Some metals react a lot and others hardly react at all. Potassium reacts very strongly — it even fizzes with cold water. Copper and gold barely react, so potassium is the most reactive here.",
                  detailedBody: "The reactivity series ranks metals from most to least reactive. Potassium is near the very top: it is an alkali metal that reacts vigorously, even with cold water, releasing hydrogen and forming an alkaline solution. Iron is in the middle, while copper and gold are low down and very unreactive (which is why gold is found as the pure metal in nature). So of the metals listed, potassium is the most reactive.",
                  tip: "Group I metals like potassium are very reactive."),
            .init(id: 408, stem: "A halogen atom in Group VII typically reacts by…", options: ["Losing one electron", "Gaining one electron", "Losing two electrons", "Staying unreactive"], correctIndex: 1, topic: "Bonding", lessonTitle: "Halogens gaining electrons",
                  simpleBody: "Halogens, like chlorine, have 7 electrons in their outer layer but 'want' 8 to be full. So they grab one more electron from another atom. This makes them into a negative ion with a 1− charge.",
                  detailedBody: "Halogens are the Group VII non-metals. They have seven electrons in their outer shell, so they only need to gain one more to achieve a full, stable outer shell of eight. When a halogen gains that electron it forms a negative ion with a 1− charge, for example a chloride ion, Cl⁻. This is why halogens are reactive non-metals. So a Group VII atom typically reacts by gaining one electron.",
                  tip: "Seven outer electrons → gain one to reach eight."),
            .init(id: 409, stem: "What colour does universal indicator turn in a strong alkali?", options: ["Red", "Green", "Purple", "Yellow"], correctIndex: 2, topic: "Acids and bases", lessonTitle: "Universal indicator",
                  simpleBody: "Universal indicator is a liquid or paper that changes colour to show acids and alkalis. In a strong alkali it turns purple. (In a strong acid it turns red, and green means neutral.)",
                  detailedBody: "Universal indicator shows the pH of a solution by changing colour across a range. In a strong alkali (high pH, around 13–14) it turns purple/violet. Neutral solutions (pH 7) turn it green, weak acids turn it orange or yellow, and strong acids (low pH) turn it red. So in a strong alkali universal indicator turns purple.",
                  tip: "Purple = strongly alkaline."),
            .init(id: 410, stem: "Metallic bonding is best described as…", options: ["Positive ions in a sea of delocalised electrons", "Shared pairs of electrons between two atoms", "The transfer of electrons to a non-metal", "Weak forces between molecules"], correctIndex: 0, topic: "Bonding", lessonTitle: "Metallic bonding",
                  simpleBody: "In a metal, the atoms turn into positive bits that sit in a 'sea' of electrons that can move around freely. These moving electrons are what let metals carry electricity and heat so well.",
                  detailedBody: "Metallic bonding is the force that holds metals together. The metal atoms lose their outer electrons, which become delocalised (free to move), forming a 'sea' of electrons around a regular lattice of positive metal ions. The strong attraction between the positive ions and this sea of electrons is the metallic bond. The free-moving electrons explain why metals conduct electricity and heat. So metallic bonding is positive ions in a sea of delocalised electrons.",
                  tip: "Metal = positive ions + sea of free electrons.")
        ]
    )

    // MARK: Mathematics · Paper 1 (questions 501–510)
    static let maths1 = Paper(
        id: 6, subject: "Mathematics", code: "4024/11", session: "May/June 2026",
        paperTitle: "Paper 1 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 501, stem: "Evaluate 3 + 4 × 2.", options: ["14", "11", "10", "24"], correctIndex: 1, topic: "Order of operations", lessonTitle: "BIDMAS / order of operations",
                  simpleBody: "There is an order for doing sums. You always do multiply (×) before add (+). So first work out 4 × 2 = 8. Then add the 3: 8 + 3 = 11.",
                  detailedBody: "This tests the order of operations (BIDMAS: Brackets, Indices, Division/Multiplication, Addition/Subtraction). Multiplication is done before addition, so you must work out 4 × 2 = 8 first, and only then add: 3 + 8 = 11. A common mistake is to work left to right (3 + 4 = 7, then × 2 = 14), which gives the wrong answer 14. The correct value is 11.",
                  tip: "Do × and ÷ before + and −."),
            .init(id: 502, stem: "Simplify 3x + 5x − 2x.", options: ["6x", "10x", "8x", "4x"], correctIndex: 0, topic: "Algebra", lessonTitle: "Collecting like terms",
                  simpleBody: "All of these terms have an 'x', so they are the same type and can be added together. Just work out the numbers in front: 3 + 5 − 2 = 6. So the answer is 6x.",
                  detailedBody: "These are 'like terms' because they all contain the same variable, x, so they can be combined. To simplify, add and subtract the coefficients (the numbers in front of x): 3 + 5 − 2 = 6. The x stays the same, giving 6x. You only combine terms that have exactly the same variable part. So 3x + 5x − 2x = 6x.",
                  tip: "Just combine the numbers in front of x."),
            .init(id: 503, stem: "What is 25% of 80?", options: ["16", "20", "25", "40"], correctIndex: 1, topic: "Percentages", lessonTitle: "Finding a percentage",
                  simpleBody: "'Per cent' means 'out of 100'. 25% is the same as one quarter (¼). To find a quarter of 80, split it into 4 equal parts: 80 ÷ 4 = 20.",
                  detailedBody: "A percentage is a fraction out of 100, so 25% = 25/100 = ¼. Finding 25% of a number is the same as dividing it by 4: 80 ÷ 4 = 20. You could also multiply by the decimal form: 80 × 0.25 = 20. So 25% of 80 is 20.",
                  tip: "25% = ÷4."),
            .init(id: 504, stem: "Calculate 5² − 3².", options: ["4", "16", "8", "34"], correctIndex: 1, topic: "Powers", lessonTitle: "Squaring numbers",
                  simpleBody: "A small ² means 'times itself'. So 5² = 5 × 5 = 25, and 3² = 3 × 3 = 9. Now subtract: 25 − 9 = 16.",
                  detailedBody: "The small raised 2 is an index (power) meaning the number is multiplied by itself, so 5² = 5 × 5 = 25 and 3² = 3 × 3 = 9. Work out each square first (indices come before subtraction in BIDMAS), then subtract: 25 − 9 = 16. A common error is to do (5 − 3)² = 4, which is wrong. The answer is 16.",
                  tip: "Square each number first, then subtract."),
            .init(id: 505, stem: "Solve for x: 2x + 3 = 11.", options: ["x = 4", "x = 7", "x = 5", "x = 8"], correctIndex: 0, topic: "Equations", lessonTitle: "Solving linear equations",
                  simpleBody: "You want to get x on its own. First take 3 away from both sides: 2x = 8. Then, because 2x means 2 times x, split both sides by 2: x = 4.",
                  detailedBody: "To solve a linear equation, undo the operations step by step to isolate x. Start with 2x + 3 = 11. Subtract 3 from both sides to get 2x = 8. Then divide both sides by 2 to get x = 4. You can check by substituting back: 2 × 4 + 3 = 11 ✓. So x = 4.",
                  tip: "Undo +3 first, then undo ×2."),
            .init(id: 506, stem: "The area of a triangle with base 10 cm and height 6 cm is…", options: ["30 cm²", "60 cm²", "16 cm²", "32 cm²"], correctIndex: 0, topic: "Mensuration", lessonTitle: "Area of a triangle",
                  simpleBody: "To find the area of a triangle, use: area = ½ × base × height. Put the numbers in: ½ × 10 × 6. Half of 60 is 30, so the area is 30 cm².",
                  detailedBody: "The area of a triangle is given by the formula area = ½ × base × height. Substituting base = 10 cm and height = 6 cm: area = ½ × 10 × 6 = ½ × 60 = 30 cm². The most common mistake is forgetting the ½ and getting 60. Area is measured in square units, so the answer is 30 cm².",
                  tip: "Don't forget the ½."),
            .init(id: 507, stem: "Write 3/4 as a percentage.", options: ["34%", "43%", "75%", "60%"], correctIndex: 2, topic: "Fractions", lessonTitle: "Fraction to percentage",
                  simpleBody: "To turn a fraction into a percentage, divide the top by the bottom, then times by 100. So 3 ÷ 4 = 0.75, and 0.75 × 100 = 75%.",
                  detailedBody: "To convert a fraction to a percentage, first divide the numerator (top) by the denominator (bottom): 3 ÷ 4 = 0.75. Then multiply by 100 to turn the decimal into a percentage: 0.75 × 100 = 75%. It helps to memorise common ones: ½ = 50%, ¼ = 25%, ¾ = 75%. So 3/4 = 75%.",
                  tip: "Divide top by bottom, then ×100."),
            .init(id: 508, stem: "What is the next term in the sequence 2, 5, 8, 11, …?", options: ["12", "13", "14", "15"], correctIndex: 2, topic: "Sequences", lessonTitle: "Linear sequences",
                  simpleBody: "Look at how the numbers change: 2, 5, 8, 11 — each one is 3 more than the last. So to get the next number, add 3 to 11: 11 + 3 = 14.",
                  detailedBody: "This is a linear (arithmetic) sequence, where you add the same amount each time. The common difference here is +3 (2→5→8→11 all go up by 3). To find the next term, add the common difference to the last term: 11 + 3 = 14. So the next term is 14.",
                  tip: "Find the step, then add it on."),
            .init(id: 509, stem: "Find the median of 3, 7, 9, 4, 5.", options: ["4", "5", "7", "9"], correctIndex: 1, topic: "Statistics", lessonTitle: "The median",
                  simpleBody: "The median is just the middle number. But first you must put the numbers in order from smallest to biggest: 3, 4, 5, 7, 9. The one in the middle is 5.",
                  detailedBody: "The median is the middle value when the data is arranged in order. First put the numbers in order: 3, 4, 5, 7, 9. With five values, the middle one (the 3rd) is 5. If there were an even number of values you would take the mean of the middle two. Don't confuse it with the mean (the total ÷ 5). So the median is 5.",
                  tip: "Order the data first, then pick the middle."),
            .init(id: 510, stem: "A fair six-sided die is rolled. What is the probability of an even number?", options: ["1/6", "1/3", "1/2", "2/3"], correctIndex: 2, topic: "Probability", lessonTitle: "Simple probability",
                  simpleBody: "A dice has 6 sides: 1, 2, 3, 4, 5, 6. Three of these are even numbers (2, 4, 6). So the chance of rolling an even number is 3 out of 6, which is the same as ½.",
                  detailedBody: "Probability = number of favourable outcomes ÷ total number of outcomes. A fair die has 6 equally likely outcomes. The even numbers are 2, 4 and 6, so there are 3 favourable outcomes. Probability = 3/6, which simplifies to 1/2. So the probability of rolling an even number is 1/2.",
                  tip: "Favourable outcomes ÷ total outcomes.")
        ]
    )

    // MARK: Mathematics · Paper 2 (questions 601–610)
    static let maths2 = Paper(
        id: 7, subject: "Mathematics", code: "4024/12", session: "Oct/Nov 2025",
        paperTitle: "Paper 1 Multiple Choice", duration: "1 hour", marks: "40 marks",
        questions: [
            .init(id: 601, stem: "Simplify the ratio 12 : 18.", options: ["2 : 3", "3 : 2", "6 : 9", "1 : 2"], correctIndex: 0, topic: "Ratio", lessonTitle: "Simplifying ratios",
                  simpleBody: "To simplify a ratio, divide both numbers by the same thing. Both 12 and 18 can be divided by 6: 12 ÷ 6 = 2 and 18 ÷ 6 = 3. So 12 : 18 becomes 2 : 3.",
                  detailedBody: "Simplifying a ratio is like simplifying a fraction: divide both parts by their highest common factor (HCF). The HCF of 12 and 18 is 6, so 12 ÷ 6 = 2 and 18 ÷ 6 = 3, giving 2 : 3. The ratio is fully simplified when the two numbers share no common factor. So 12 : 18 = 2 : 3.",
                  tip: "Divide both sides by the same number."),
            .init(id: 602, stem: "The circumference of a circle of radius 7 cm is (take π ≈ 22/7)…", options: ["22 cm", "44 cm", "14 cm", "154 cm"], correctIndex: 1, topic: "Mensuration", lessonTitle: "Circumference of a circle",
                  simpleBody: "The distance all the way around a circle is called the circumference. The rule is: circumference = 2 × π × radius. So 2 × 22/7 × 7 = 44 cm.",
                  detailedBody: "The circumference (distance around a circle) is found with C = 2πr, where r is the radius. Here r = 7 cm and π ≈ 22/7, so C = 2 × 22/7 × 7 = 44 cm (the 7s cancel neatly). Be careful not to use the area formula A = πr², which would give 154 cm² — that is why that wrong option is there. So the circumference is 44 cm.",
                  tip: "Circumference uses 2πr; area uses πr²."),
            .init(id: 603, stem: "Expand 2(x + 5).", options: ["2x + 5", "2x + 10", "x + 10", "2x + 7"], correctIndex: 1, topic: "Algebra", lessonTitle: "Expanding brackets",
                  simpleBody: "Expanding means multiplying everything inside the bracket by the number outside. Here that number is 2: 2 × x = 2x, and 2 × 5 = 10. So you get 2x + 10.",
                  detailedBody: "To expand a single bracket, multiply the term outside by each term inside (the distributive law). Here 2 × x = 2x and 2 × 5 = 10, so 2(x + 5) = 2x + 10. A common mistake is to multiply only the first term and write 2x + 5; both terms must be multiplied. So the answer is 2x + 10.",
                  tip: "Multiply the outside number by each term inside."),
            .init(id: 604, stem: "If y = 3x and x = 4, what is y?", options: ["7", "12", "34", "1"], correctIndex: 1, topic: "Substitution", lessonTitle: "Substituting values",
                  simpleBody: "This just means swap the letter for its number. Since x = 4, replace the x: y = 3 × 4 = 12.",
                  detailedBody: "Substitution means replacing a letter with its given value and then calculating. Here y = 3x means '3 times x'. Putting in x = 4 gives y = 3 × 4 = 12. Remember that a number written next to a letter means multiply. So y = 12.",
                  tip: "Swap the letter for its value, then calculate."),
            .init(id: 605, stem: "The interior angles of a triangle add up to…", options: ["90°", "180°", "270°", "360°"], correctIndex: 1, topic: "Geometry", lessonTitle: "Angles in a triangle",
                  simpleBody: "The three angles inside any triangle always add up to 180°. This is true for every triangle, no matter its shape.",
                  detailedBody: "The interior angles of any triangle always add up to 180°. You can use this to find a missing angle by subtracting the two known angles from 180°. For comparison, the interior angles of a quadrilateral add up to 360°. So the interior angles of a triangle sum to 180°.",
                  tip: "Triangle = 180°, quadrilateral = 360°."),
            .init(id: 606, stem: "Write 0.2 as a fraction in its simplest form.", options: ["1/2", "1/5", "2/10", "1/4"], correctIndex: 1, topic: "Fractions", lessonTitle: "Decimals to fractions",
                  simpleBody: "0.2 means 'two tenths', which you can write as 2/10. Now make it simpler by dividing the top and bottom by 2: that gives 1/5.",
                  detailedBody: "To turn a decimal into a fraction, use place value. The 2 is in the tenths column, so 0.2 = 2/10. Then simplify by dividing the numerator and denominator by their highest common factor, 2: 2/10 = 1/5. So 0.2 as a fraction in its simplest form is 1/5.",
                  tip: "Write over 10, then simplify."),
            .init(id: 607, stem: "Factorise x² + 3x.", options: ["x(x + 3)", "(x + 1)(x + 3)", "x² + 3", "3x²"], correctIndex: 0, topic: "Algebra", lessonTitle: "Common factor",
                  simpleBody: "Factorising is the opposite of expanding — you take a common part OUT. Both x² and 3x contain an x, so pull the x out to the front: x(x + 3).",
                  detailedBody: "Factorising means writing an expression as a product by taking out the highest common factor. Both terms, x² and 3x, share a factor of x. Taking x outside the bracket leaves x and 3, so x² + 3x = x(x + 3). You can check by expanding: x × x = x² and x × 3 = 3x ✓. So the factorised form is x(x + 3).",
                  tip: "Look for a factor common to every term."),
            .init(id: 608, stem: "Find the mean of 4, 8, 6 and 2.", options: ["4", "5", "6", "20"], correctIndex: 1, topic: "Statistics", lessonTitle: "The mean",
                  simpleBody: "To find the mean (a type of average), add all the numbers up, then divide by how many there are. 4 + 8 + 6 + 2 = 20, and there are 4 numbers, so 20 ÷ 4 = 5.",
                  detailedBody: "The mean is the most common average: add all the values, then divide by how many values there are. Here the total is 4 + 8 + 6 + 2 = 20, and there are 4 numbers, so the mean = 20 ÷ 4 = 5. Don't mix it up with the median (middle value) or mode (most common value). So the mean is 5.",
                  tip: "Mean = total ÷ number of values."),
            .init(id: 609, stem: "Solve 3x = 27.", options: ["x = 6", "x = 9", "x = 3", "x = 24"], correctIndex: 1, topic: "Equations", lessonTitle: "One-step equations",
                  simpleBody: "3x means 3 times x. To find x, do the opposite of multiplying — divide both sides by 3: 27 ÷ 3 = 9. So x = 9.",
                  detailedBody: "To solve 3x = 27, undo the multiplication by dividing both sides by 3: x = 27 ÷ 3 = 9. You can check by substituting back: 3 × 9 = 27 ✓. So x = 9.",
                  tip: "Undo the ×3 by dividing by 3."),
            .init(id: 610, stem: "A car travels 150 km in 3 hours. What is its average speed?", options: ["45 km/h", "50 km/h", "60 km/h", "15 km/h"], correctIndex: 1, topic: "Speed", lessonTitle: "Speed = distance ÷ time",
                  simpleBody: "Speed tells you how fast something goes. The rule is: speed = distance ÷ time. So 150 km ÷ 3 hours = 50 km/h (kilometres per hour).",
                  detailedBody: "Average speed is calculated with the formula speed = distance ÷ time. Here the distance is 150 km and the time is 3 hours, so speed = 150 ÷ 3 = 50 km/h. The unit km/h comes from dividing kilometres by hours. So the average speed is 50 km/h.",
                  tip: "Divide the distance by the time.")
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
