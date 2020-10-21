export enum GameCardStatus {
  HIDDEN,
  SHOWN,
  REMOVED,
}

const assetPrefix = '../assets/images/';
export const resources = {
  '1': require(assetPrefix + 'i011_carrot.png'),
  '2': require(assetPrefix + 'i012_owl.png'),
  '3': require(assetPrefix + 'i013_corn.png'),
  '4': require(assetPrefix + 'i020_chestnut.png'),
  '5': require(assetPrefix + 'i014_orange.png'),
  '6': require(assetPrefix + 'i015_pear.png'),
  '7': require(assetPrefix + 'i016_fig.png'),
  '8': require(assetPrefix + 'i017_pomegranate.png'),
  '9': require(assetPrefix + 'i018_bee.png'),
  '10': require(assetPrefix + 'i019_bear.png'),
};

export default class GameCard {
  public state = GameCardStatus.HIDDEN;
  public pair?: GameCard;

  constructor(public readonly number: number) {}
}
